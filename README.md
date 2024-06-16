# WeatherApplication

WeatherApplication is a weather application built using SwiftUI and Combine. It provides real-time weather updates for the user's current location or a specified city. The app utilizes the OpenWeatherMap API to fetch weather data and displays it in an intuitive and user-friendly interface.

## Features

- Real-time weather updates for the user's current location.
- Weather updates for a specified city.
- Displays current temperature, weather conditions, wind speed, humidity, and rain chances.
- Interactive UI with smooth loading animations.

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.3+

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/gembalisandesh/WeatherApplication.git
   ```
2. Open the project in Xcode:
   ```sh
   cd WeatherApplication
   open WeatherApplication.xcodeproj
   ```
3. Build and run the project on your simulator or device.

## API Key

This project uses the OpenWeatherMap API. To fetch weather data, you need an API key.

1. Go to [OpenWeatherMap](https://openweathermap.org/api) and sign up for a free account.
2. Get your API key from the OpenWeatherMap dashboard.
3. Replace the placeholder API key in `NetworkManager.swift` with your actual API key:
   ```swift
   struct API {
       static let key = "YOUR_API_KEY"
   }
   ```

## Project Structure

The project consists of the following main components:

### 1. `NetworkManager.swift`

Handles all the network requests to fetch weather data from the OpenWeatherMap API.

### 2. `LocationManager.swift`

Manages location services to get the current location of the user.

### 3. `WeatherViewModel.swift`

Acts as the ViewModel in the MVVM architecture. It handles the business logic and data manipulation for the weather data.

### 4. `ContentView.swift`

The main view of the application. It uses SwiftUI to build the user interface and displays the weather information.

### Code Explanation

#### NetworkManager.swift

- `fetch(for url: URL)`: Fetches weather data from the provided URL using `URLSession`.

#### LocationManager.swift

- `getCurrentLocation()`: Fetches the current location of the user.
- `locationManager(_:didUpdateLocations:)`: Updates the current location.
- `locationManager(_:didFailWithError:)`: Handles location fetching errors.

#### WeatherViewModel.swift

- `getWeatherForCurrentLocation()`: Fetches weather data for the current location.
- `getCityName(from coordinate: CLLocationCoordinate2D)`: Gets the city name from coordinates using reverse geocoding.
- `getTempFor(temp: Double)`: Converts temperature from Fahrenheit to Celsius.
- `getWeatherIconFor(icon: String)`: Gets the appropriate SF Symbol for the weather icon.
- `refreshWeather()`: Refreshes the weather data.

#### ContentView.swift

- The main SwiftUI view that displays the weather information. It includes a header for entering city names and buttons for refreshing weather data.

## Screenshots

![Simulator Screenshot - iPhone 15 - 2024-06-17 at 02 16 39](https://github.com/gembalisandesh/WeatherApplication/assets/93411433/c574680f-bce3-4d29-9f68-de4abe56d4f4)
![Simulator Screenshot - iPhone 15 - 2024-06-17 at 02 16 07](https://github.com/gembalisandesh/WeatherApplication/assets/93411433/ca2e6839-3439-42f1-80af-fda2110b9c81)
![Simulator Screenshot - iPhone 15 - 2024-06-17 at 02 16 17](https://github.com/gembalisandesh/WeatherApplication/assets/93411433/83fe651b-1545-4682-a646-66d8b87d6dc5)
![Simulator Screenshot - iPhone 15 - 2024-06-17 at 02 16 35](https://github.com/gembalisandesh/WeatherApplication/assets/93411433/2b7b8c65-5e8e-4163-a562-850e4efadba5)


## Acknowledgements

- [OpenWeatherMap API](https://openweathermap.org/api) for providing the weather data.
- SwiftUI and Combine for making development easier and more efficient.
