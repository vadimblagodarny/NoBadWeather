//
//  MainViewModel.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 05.10.2023.
//

import Foundation
import CoreLocation

protocol IMainViewModel {
    var networkManager: INetworkManager! { get }
    var locationManager: ILocationManager! { get }
    var weatherCurrentSignal: Bindable<WeatherCurrent?> { get }
    var weatherForecastSignal: Bindable<WeatherForecast?> { get }
    
    init(networkManager: INetworkManager, locationManager: ILocationManager)
    
    func getWeather(name: String?, completion: @escaping (CLError?) -> Void)
}

final class MainViewModel: IMainViewModel {
    var networkManager: INetworkManager!
    var locationManager: ILocationManager!
    var weatherCurrentSignal: Bindable<WeatherCurrent?> = Bindable(value: nil)
    var weatherForecastSignal: Bindable<WeatherForecast?> = Bindable(value: nil)
    
    init(networkManager: INetworkManager, locationManager: ILocationManager) {
        self.networkManager = networkManager
        self.locationManager = locationManager
    }

    func getWeather(name: String?, completion: @escaping (CLError?) -> Void) {
        locationManager.getLocation(name: name) { [weak self] location, clError in
            guard let self = self else { return }

            if let clError {
                completion(clError)
                return
            }

            guard let location = location else { return }
            let endpoint = "?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&lang=ru"
            self.networkManager.sendRequest(api: RequestAPI.weather, endpoint: endpoint, requestType: .GET, parser: self.parser)
            self.networkManager.sendRequest(api: RequestAPI.forecast, endpoint: endpoint, requestType: .GET, parser: self.parser)
        }
    }
    
    func parser(data: Data, api: RequestAPI) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        switch api {
        case .weather:
            let decoded = try? decoder.decode(WeatherCurrent.self, from: data)
            weatherCurrentSignal.value = decoded
        case .forecast:
            let decoded = try? decoder.decode(WeatherForecast.self, from: data)
            weatherForecastSignal.value = decoded
        }
    }
}
