//
//  LocationManager.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 07.10.2023.
//

import Foundation
import CoreLocation

protocol ILocationManager {
    func getLocation(name: String?, completion: @escaping (CLLocation?, CLError?) -> Void)
}

final class LocationManager: NSObject, CLLocationManagerDelegate, ILocationManager {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    var completion: ((CLLocation?, CLError?) -> Void)?
    
    func getLocation(name: String?, completion: @escaping (CLLocation?, CLError?) -> Void) {
        if let name = name {
            geocoder.geocodeAddressString(name) { location, error in
                self.completion = completion
                completion(location?.first?.location, error as? CLError)
            }
        } else {
            self.completion = completion
            manager.requestWhenInUseAuthorization()
            manager.delegate = self
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        completion?(location, nil)
        manager.stopUpdatingLocation()
    }
}
