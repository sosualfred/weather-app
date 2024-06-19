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
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    
    @Published var forecasts: [ForecastViewModel] = []
    @Published var isLoading: Bool = false
    @AppStorage("location") var location: String = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    var appError: AppError? = nil
    
    init(){
        if !location.isEmpty {
            getWeatherForecast()
        }
    }
    
    func getWeatherForecast() {
        isLoading = true
        let apiService = ApiService.shared;
        CLGeocoder().geocodeAddressString(location){(placeMarks, error) in
            if let error = error {
                self.isLoading = false
                self.appError = AppError(errorString: error.localizedDescription)
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
                            self.isLoading = false
                            self.forecasts = forecast.daily.map{ForecastViewModel(forecast: $0, system: self.system)}
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            self.isLoading = false
                            self.appError = AppError(errorString: errorString)
                            print(errorString);
                        }
                    }
                }
            }
        };
    }
}
