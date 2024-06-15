//
//  CurrentWeatherView.swift
//  WeatherApp-SwiftUI
//
//  Created by Gembali Sandesh Kumar on 15/06/24
//

import SwiftUI

struct CurrentWeatherView: View {
    
    @ObservedObject var cityVM: WeatherViewModel

    var body: some View {

        VStack(spacing: 10) {
            
            Text("Today")
                .font(.largeTitle)
                .bold()
            
                
                VStack(alignment: .leading) {
                    
//                        cityVM.getWeatherIconFor(icon: weather.weather.count > 0 ? weather.weather[0].icon : "sun.max.fill")
//                        
                        Text("\(cityVM.DailyWeatherTemp)℃")
                            .font(.system(size: 42))
                        
                    
                    
                    HStack{
                        cityVM.getWeatherIconFor(icon: cityVM.weatherModel.current.weather.count > 0 ? cityVM.weatherModel.current.weather[0].icon : "sun.max.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                        Text(cityVM.conditions)
                    }
                    
                    
                }
            
            HStack {
                
                Spacer()
                
                widgetView(image: "wind", color: .green, title: "\(cityVM.windSpeed)km/hr")
                
                Spacer()
                
                widgetView(image: "drop.fill", color: .blue, title: "\(cityVM.humidity)")
                
                Spacer()
                
                widgetView(image: "umbrella.fill", color: .red, title: "\(cityVM.rainChances)")
                
                Spacer()
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 20).fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]), startPoint: .top, endPoint: .bottom)).opacity(0.3))
        .shadow(color: Color.white.opacity(0.1), radius: 2, x: -2, y: -2)
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
    }
    
    private func widgetView(image: String, color: Color, title: String) -> some View {
        
        VStack {
            
            Image(systemName: image)
                .padding()
                .font(.title)
                .foregroundColor(color)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            
            Text(title)
        }
    }
}


