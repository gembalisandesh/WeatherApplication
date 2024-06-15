//
//  HeaderView.swift
//  WeatherApp-SwiftUI
//
//  Created by Gembali Sandesh Kumar on 15/06/24
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var cityVM: WeatherViewModel // ViewModel for weather data
    @Binding var showAlert: Bool // Binding to show alert for location access
    @State private var searchTerm = "Noida" // Default search term

    var body: some View {
        HStack {
            TextField("", text: $searchTerm) // Text field to enter city name
                .padding(.leading, 20)
            
            Button(action: {
                cityVM.city = searchTerm // Update city in ViewModel when search button is tapped
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.brown)
                    
                    Image(systemName: "location.fill") // Location icon
                }
            }
            .frame(width: 50, height: 50)
            
            Button(action: {
                if !cityVM.locationManager.isAuthorized {
                    showAlert = true // Show alert if location access is not authorized
                } else {
                    cityVM.refreshWeather() // Refresh weather data
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                    Image(systemName: "arrow.clockwise") // Refresh icon
                }
            }
            .frame(width: 50, height: 50)
        }
        .foregroundColor(.white)
        .padding()
        .background(ZStack(alignment: .leading) {
            Image(systemName: "magnifyingglass") // Search icon
                .foregroundColor(.white)
                .padding(.leading, 10)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.5)) // Background for search field
        })
    }
}
