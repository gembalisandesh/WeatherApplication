//
//  WeatherViewModel.swift
//  WeatherApp-SwiftUI
//
//  Created by Gembali Sandesh Kumar on 15/06/24
//

import SwiftUI
import Combine
import CoreLocation
final class WeatherViewModel: ObservableObject {
    @Published var weatherModel = WeatherModel.empty()
    
    let locationManager = LocationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var city: String = "Noida" {
        didSet {
            getLocation() // Call getLocation whenever the city changes
        }
    }
    @Published var invalidCity: Bool = false // Indicates if the current city is invalid

    // MARK: - Initialization
    
    init() {
        getLocation() // Initialize by fetching weather for the default city
    }
    
    // MARK: - Weather Data Fetching
    
    /// Fetches weather data for the current location based on device's GPS coordinates.
    func getWeatherForCurrentLocation() {
        locationManager.getCurrentLocation()
            .compactMap { $0 }
            .flatMap { coordinate in
                self.getCityName(from: coordinate)
                    .map { (coordinate, $0) }
                    .eraseToAnyPublisher()
            }
            .map { API.getURLFor(lat: $0.0.latitude, lon: $0.0.longitude) }
            .flatMap { NetworkManager<WeatherModel>.fetch(for: URL(string: $0)!) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching weather data: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.weatherModel = response
            })
            .store(in: &cancellables)
    }

    /// Retrieves the city name from coordinates using reverse geocoding.
    private func getCityName(from coordinate: CLLocationCoordinate2D) -> AnyPublisher<String, Never> {
        let subject = PassthroughSubject<String, Never>()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let city = placemarks?.first?.locality {
                self.city = city // Update city name when found
                subject.send(city)
            } else {
                subject.send("Unknown")
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Formatting
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    /// Formats the date from timestamp to a full date string.
    var date: String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weatherModel.current.dt)))
    }
    
    /// Retrieves the appropriate weather icon based on current weather conditions.
    var weatherIcon: String {
        if weatherModel.current.weather.count > 0 {
            return weatherModel.current.weather[0].icon
        }
        return "dayClearSky"
    }
    
    // MARK: - Weather Information
    
    /// Retrieves the current temperature in Celsius.
    var DailyWeatherTemp: String {
        return getTempFor(temp: weatherModel.current.temp)
    }
    
    /// Retrieves the current weather conditions description.
    var conditions: String {
        if weatherModel.current.weather.count > 0 {
            return weatherModel.current.weather[0].main
        }
        return ""
    }
    
    /// Retrieves the wind speed in miles per hour (converted from meters per second).
    var windSpeed: String {
        return String(format: "%0.1f", weatherModel.current.wind_speed / 1.60934)
    }
    
    /// Retrieves the humidity percentage.
    var humidity: String {
        return String(format: "%d%%", weatherModel.current.humidity)
    }
    
    /// Retrieves the chance of rain in percentage.
    var rainChances: String {
        return String(format: "%0.0f%%", weatherModel.current.dew_point)
    }
    
    // MARK: - Temperature Conversion
    
    /// Converts temperature from Fahrenheit to Celsius.
    func getTempFor(temp: Double) -> String {
        return String(format: "%0.1f", 5.0/9*(temp-32))
    }
    
    // MARK: - Date Formatting
    
    /// Converts timestamp to day of the week abbreviation (e.g., Mon, Tue).
    func getDayFor(timestamp: Int) -> String {
        return dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    // MARK: - Location and Weather Fetching
    
    /// Initiates the process of fetching weather for the current city.
    private func getLocation() {
        CLGeocoder().geocodeAddressString(city) { (placemarks, error) in
            if let places = placemarks, let place = places.first {
                self.getWeather(coord: place.location?.coordinate)
                self.invalidCity = false
            } else {
                self.invalidCity = true
            }
        }
    }
    
    /// Fetches weather data based on provided coordinates.
    private func getWeather(coord: CLLocationCoordinate2D?) {
        if let coord = coord {
            let urlString = API.getURLFor(lat: coord.latitude, lon: coord.longitude)
            getWeatherInternal(city: city, for: urlString)
        } else {
            // Default location coordinates used when current location is unavailable
            let urlString = API.getURLFor(lat: 37.5485, lon: -121.9886)
            getWeatherInternal(city: city, for: urlString)
        }
    }
    
    /// Fetches weather data from the API using the provided URL.
    private func getWeatherInternal(city: String, for urlString: String) {
        guard let url = URL(string: urlString) else { return }

        NetworkManager<WeatherModel>.fetch(for: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching weather data: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.weatherModel = response
            })
            .store(in: &cancellables)
    }
    
    // MARK: - UI Helpers
    
    /// Retrieves the appropriate SF Symbol image for the given weather icon code.
    func getWeatherIconFor(icon: String) -> Image {
        switch icon {
        case "01d":
            return Image(systemName: "sun.max.fill")
        case "01n":
            return Image(systemName: "moon.fill")
        case "02d":
            return Image(systemName: "cloud.sun.fill")
        case "02n":
            return Image(systemName: "cloud.moon.fill")
        case "03d", "03n", "04d", "04n":
            return Image(systemName: "cloud.fill")
        case "09d", "09n":
            return Image(systemName: "cloud.drizzle.fill")
        case "10d", "10n":
            return Image(systemName: "cloud.heavyrain.fill")
        case "11d", "11n":
            return Image(systemName: "cloud.bolt.fill")
        case "13d", "13n":
            return Image(systemName: "cloud.snow.fill")
        case "50d", "50n":
            return Image(systemName: "cloud.fog.fill")
        default:
            return Image(systemName: "sun.max.fill")
        }
    }

    // MARK: - Actions
    
    /// Initiates a refresh of weather data based on current location or city.
    func refreshWeather() {
        if let location = locationManager.currentLocation {
            let urlString = API.getURLFor(lat: location.latitude, lon: location.longitude)
            getWeatherInternal(city: city, for: urlString)
            getCityName(from: location)
                .sink(receiveValue: { city in
                    self.city = city
                })
                .store(in: &cancellables)
        } else {
            getWeatherForCurrentLocation()
        }
    }
}
