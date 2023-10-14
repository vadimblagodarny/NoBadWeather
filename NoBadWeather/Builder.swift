//
//  Builder.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 08.10.2023.
//

import UIKit

protocol IBuilder {
    static func createMainView() -> UIViewController
}

class Builder: IBuilder {
    static func createMainView() -> UIViewController {
        let networkManager = NetworkManager()
        let locationManager = LocationManager()
        let viewModel = MainViewModel(networkManager: networkManager, locationManager: locationManager)
        let view = MainView(viewModel: viewModel)
        return view
    }
}
