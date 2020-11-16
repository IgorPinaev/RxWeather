//
//  WeatherLocationViewModel.swift
//  RxWeather
//
//  Created by Игорь Пинаев on 10.10.2020.
//  Copyright © 2020 Igor Pinaev. All rights reserved.
//

import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class WeatherLocationViewModel: AbstractWeatherViewModel {
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let refreshControlSignal: Signal<Void>
    }
    
    struct Output {
        let tableData: Driver<[MultipleSectionModel]>
        let isLoading: Driver<Bool>
        let error: Signal<Error>
        let showSettingsLink: Driver<Bool>
    }
    
    func configure(with input: Input) -> Output {
        locationManager.distanceFilter = 10
        
        let startLoadingData = input.refreshControlSignal
            .startWith(())
            .asObservable()
            .share()
        
        let status = locationManager.rx
            .status
            .map { [.authorizedAlways, .authorizedWhenInUse].contains($0) }
            .share()
        
        let updateStatus = locationManager.rx
            .didChangeAuthorization
            .map { [.authorizedAlways, .authorizedWhenInUse].contains($1) }
            .share()
        
        let observableStatus = Observable.merge(status, updateStatus)
            .share()
        
        observableStatus
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if $0 {
                    self.locationManager.startUpdatingLocation()
                } else {
                    self.locationManager.requestAlwaysAuthorization()
                }
            })
            .disposed(by: disposeBag)
        
        let showSettingsLink = observableStatus
            .asDriver(onErrorJustReturn: true)
        
        let location = startLoadingData
            .flatMapLatest({ [weak self] _ -> Observable<CLLocation> in
                guard let self = self else { throw ApiError.unknownError }
                return self.locationManager.rx
                    .location
                    .compactMap { $0 }
            })
            .share()
        
        let placemark = locationManager.rx
            .placemark
            .compactMap { $0 }
        
        let response = location
            .flatMapLatest { [weak self] location -> Observable<Event<OneCallResponse>> in
                guard let self = self else { throw ApiError.unknownError }
                return self.apiService.loadData(with: OneCallResponse.self, endpoint: OpenWeather.oneCall(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
                    .materialize()
            }
            .share()
        
        let error = response
            .compactMap { $0.error }
            .asSignal(onErrorJustReturn: ApiError.unknownError)
        
        let tableData = response
            .compactMap { $0.element }
            .withLatestFrom(placemark) { ($0, $1.locality) }
            .map({ [weak self] in
                return self?.getSections(response: $0.0, name: $0.1) ?? []
            })
            .asDriver(onErrorJustReturn: [])
        
        let isLoading = Observable.merge(startLoadingData.map { true }, response.map { _ in false })
            .asDriver(onErrorJustReturn: false)
        
        return Output(tableData: tableData, isLoading: isLoading, error: error, showSettingsLink: showSettingsLink)
    }
}
