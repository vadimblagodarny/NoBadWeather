//
//  NetworkManager.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 29.09.2023.
//

import Foundation

enum RequestType: String {
    case GET
    case POST
}

enum RequestAPI: String {
    case weather = "/data/2.5/weather"
    case forecast = "/data/2.5/forecast"
}

protocol INetworkManager {
    func sendRequest(api: RequestAPI, endpoint: String, requestType: RequestType, parser: @escaping (Data, RequestAPI) -> Void)
}

final class NetworkManager: INetworkManager {
    private let baseURL = "https://api.openweathermap.org"
    private let apiKey = "56d4fa81fb5e49e5bf19a78d5a21919d"

    func sendRequest(api: RequestAPI, endpoint: String, requestType: RequestType, parser: @escaping (Data, RequestAPI) -> Void) {
        guard let url = URL(string: baseURL + api.rawValue + endpoint + "&appid=" + apiKey) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error { print(error) }
            if let data {
                parser(data, api)
            }
        }
        task.resume()
    }
}
