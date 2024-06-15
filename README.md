# WeatherApp-SwiftUI

WeatherApp-SwiftUI is a weather application built using SwiftUI and Combine. It provides real-time weather updates for the user's current location or a specified city. The app utilizes the OpenWeatherMap API to fetch weather data and displays it in an intuitive and user-friendly interface.

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
   git clone https://github.com/your-username/WeatherApp-SwiftUI.git
   ```
2. Open the project in Xcode:
   ```sh
   cd WeatherApp-SwiftUI
   open WeatherApp-SwiftUI.xcodeproj
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

Add some screenshots of your application here.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [OpenWeatherMap API](https://openweathermap.org/api) for providing the weather data.
- SwiftUI and Combine for making development easier and more efficient.
