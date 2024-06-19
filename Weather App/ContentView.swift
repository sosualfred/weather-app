//
//  ContentView.swift
//  Weather App
//
//  Created by sosualfred on 17/06/2024.
//

import SDWebImageSwiftUI
import SwiftUI

struct ContentView: View {
    @StateObject var forecastListVM = ForecastListViewModel()
    
    var body: some View {
        ZStack {
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
                                WebImage(url: day.weatherIconUrl) {
                                    image in image.resizable()
                                        .scaledToFit()
                                        .frame(width: 75)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 75)
                                }
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
                .alert(item: $forecastListVM.appError) { appAlert in
                    Alert(
                        title: Text("Error"),
                        message: Text("""
                                \(appAlert.errorString)
                                Please try again later!
                            """)
                    )
                }
            }
            if forecastListVM.isLoading {
                ZStack {
                    Color(.white)
                        .opacity(0.3)
                    .ignoresSafeArea()
                    ProgressView("Fetching Weather")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius:10)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}

#Preview {
    ContentView();
}
