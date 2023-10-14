//
//  Model.swift
//  NoBadWeather
//
//  Created by Vadim Blagodarny on 29.09.2023.
//

struct WeatherCurrent: Decodable {
    let coord: Coord?
    let weather: [Weather]?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
}

struct WeatherForecast: Decodable {
    let cnt: Int?
    let list: [List]?
    let city: City?
}

struct City: Decodable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}

struct List: Decodable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let rain: Rain?
    let sys: Sys?
    let dtTxt: String?
}

struct Coord: Decodable {
    var lon: Float
    var lat: Float
}

struct Main: Decodable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let grndLevel: Int?
}

struct Clouds: Decodable {
    let all: Int?
}

struct Rain: Decodable {
    let the1H: Double?
    let the3H: Double?
}

struct Sys: Decodable {
    let pod: String?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
    }
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
