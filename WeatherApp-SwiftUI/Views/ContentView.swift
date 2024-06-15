//
//  ContentView.swift
//  WeatherApp-SwiftUI
//
//  Created by Gembali Sandesh Kumar on 15/06/24
//

import SwiftUI
import CoreLocation

struct ContentView: View {

    @ObservedObject var cityVM = WeatherViewModel() // ViewModel for weather data
    @ObservedObject var locationManager = LocationManager.shared // Shared instance of LocationManager
    @State private var isLoading = true // Loading indicator state
    @State private var showAlert = false // Flag to show alert for invalid city

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HeaderView(cityVM: cityVM, showAlert: $showAlert) // Header view with city search and refresh buttons
                    .padding()

                ScrollView(showsIndicators: false) {
                    CityStatusView(cityVM: cityVM) // Display weather details for the city
                }
                .padding(.top, 10)
            }
            .padding(.top, 40)

            if isLoading {
                LoadingView() // Show loading view while data is being fetched
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]), startPoint: .topLeading, endPoint: .topTrailing)) // Background gradient
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Simulate data loading (replace with your actual data fetching logic)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
                cityVM.refreshWeather() // Refresh weather data when view appears
            }
        }

        .alert(isPresented: $showAlert) {
            Alert(title: Text("Location Services Disabled"),
                  message: Text("Please enable location services in settings."),
                  dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $cityVM.invalidCity) {
            Alert(title: Text("Invalid City"),
                  message: Text("The city name you entered is invalid. Please enter a valid city name."),
                  dismissButton: .default(Text("OK")) {
                    cityVM.refreshWeather()
                  })
        }
    }
}

#Preview {
    ContentView()
}
