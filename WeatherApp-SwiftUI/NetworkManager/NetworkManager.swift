//
//  NetworkManager.swift
//  WeatherApp-SwiftUI
//
//  Created by Gembali Sandesh Kumar on 15/06/24
//

import Foundation
import Combine

// MARK: - API Configuration

struct API {
    static let key = "9898f76611dba534c9d721073a297ccf" // API key for OpenWeatherMap

    static let baseURLString = "https://api.openweathermap.org/data/2.5/"

    // Constructs the API URL for fetching weather data based on latitude and longitude
    static func getURLFor(lat: Double, lon: Double) -> String {
        return "\(baseURLString)onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(key)&units=imperial"
    }
}

// MARK: - Network Manager for API Requests

final class NetworkManager<T: Codable> {
    
    // Fetches data from the provided URL and decodes it to a generic type T
    static func fetch(for url: URL) -> AnyPublisher<T, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> T in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponse
                }
                return try JSONDecoder().decode(T.self, from: result.data)
            }
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.error(err: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Errors

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case error(err: String)
    case decodingError(err: String)
}
