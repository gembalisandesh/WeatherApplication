//
//  CityNameView.swift
//  WeatherApp-SwiftUI
//
//  Created by Gembali Sandesh Kumar on 15/06/24
//


import SwiftUI


struct CityNameView: View {
    
    var city: String
    var date: String

    var body: some View {

        HStack {
            
            VStack(alignment: .center, spacing: 10) {
                
                Text(city)
                    .font(.title)
                    .bold()
                
                Text(date)
                    .font(.title2)
            }
            .foregroundColor(.white)
        }
    }
}


