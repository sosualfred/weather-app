//
//  Forecast.swift
//  Weather App
//
//  Created by sosualfred on 17/06/2024.
//

import Foundation

struct Forecast: Codable {
    let timezone: String;
    struct Daily: Codable {
        let summary: String;
        let dt: Date;
        struct Temp: Codable {
            let min: Double;
            let max: Double;
        }
        let temp: Temp;
        let humidity: Int;
        struct Weather: Codable {
            let id: Int;
            let description: String;
            let icon: String;
            var weatherIconUrl : URL {
                let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png";
                return URL(string: urlString)!;
            }
        }
        let weather: [Weather];
        let clouds: Int;
        let pop: Double;
    }
    let daily: [Daily];
}
