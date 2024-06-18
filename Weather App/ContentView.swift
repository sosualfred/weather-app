//
//  ContentView.swift
//  Weather App
//
//  Created by sosualfred on 17/06/2024.
//

import CoreLocation
import SwiftUI

struct ContentView: View {
    @StateObject var forecastListVM = ForecastListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $forecastListVM.system, label: Text("System")) {
                    Text("°C").tag(0)
                    Text("°F").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical)
                HStack {
                    TextField("Enter Location", text: $forecastListVM.location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        forecastListVM.getWeatherForecast()
                    }, label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                    })
                }
                List(forecastListVM.forecasts, id: \.day) {
                    day in VStack(alignment: .leading){
                        Text(day.day)
                            .fontWeight(.bold)
                        HStack(alignment: .center) {
                            Image(systemName: "hourglass")
                                .font(.title)
                                .frame(width: 50, height: 50)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                            VStack(alignment: .leading){
                                Text(day.overview)
                                HStack {
                                    Text(day.high)
                                    Text(day.low)
                                }
                                HStack{
                                    Text(day.clouds)
                                    Text(day.pop)
                                }
                                Text(day.humidity)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
          
            }
            .padding(.horizontal)
            .navigationTitle("Weather App")
        }
    }
}

#Preview {
    ContentView();
}
