//
//  ForecastListViewModel.swift
//  Weather App
//
//  Created by sosualfred on 18/06/2024.
//

import Foundation
import CoreLocation
import SwiftUI

class ForecastListViewModel : ObservableObject {
    @Published var forecasts: [ForecastViewModel] = []
    var location: String = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    func getWeatherForecast() {
        let apiService = ApiService.shared;
        CLGeocoder().geocodeAddressString(location){(placeMarks, error) in
            if let error = error {
                print(error.localizedDescription);
            }
            
            if let lat = placeMarks?.first?.location?.coordinate.latitude,
               let lon = placeMarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(
                    urlString: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=30719886c50f90db8f77f530232222ad",
                    dateDecodingStrategy: .secondsSince1970
                ){
                    (result: Result<Forecast, ApiService.APIError>) in
                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.forecasts = forecast.daily.map{ForecastViewModel(forecast: $0, system: self.system)}
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString);
                        }
                    }
                }
            }
        };
    }
}
