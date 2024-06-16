//
//  LocationManager.swift
//  WeatherApp-SwiftUI
//
//  Created by Gembali Sandesh Kumar on 15/06/24
//

import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = LocationManager() // Shared instance for singleton pattern

    @Published var currentLocation: CLLocationCoordinate2D? // Current location coordinate
    @Published var isAuthorized: Bool = false // Location authorization status
    @Published var locationError: Error? // Any error encountered during location updates

    private var locationManager: CLLocationManager
    private var locationUpdateSubject = PassthroughSubject<CLLocationCoordinate2D?, Never>()
    private var cancellables = Set<AnyCancellable>()

    private override init() {
        self.locationManager = CLLocationManager()
        super.init()
        setupLocationManager() // Initial setup for location manager
    }

    // Request location authorization
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    // Setup location manager properties and delegate
    private func setupLocationManager() {
        DispatchQueue.global().async {
            self.locationManager.delegate = self

            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.requestAuthorization() // Request authorization if location services are enabled
            } else {
                print("Location services are not enabled.")
                self.locationError = NSError(domain: "Location Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services are not enabled."])
            }
        }
    }

    // Handle changes in authorization status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.isAuthorized = true
                self.locationManager.startUpdatingLocation() // Start updating location if authorized
            case .denied, .restricted:
                self.isAuthorized = false
                self.locationError = NSError(domain: "Location Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location access denied or restricted."])
            case .notDetermined:
                self.isAuthorized = false
                self.locationError = NSError(domain: "Location Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location authorization status not determined yet."])
            @unknown default:
                fatalError("Unhandled case in locationManagerDidChangeAuthorization.")
            }
        }
    }

    // Update location when new locations are available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        currentLocation = location
        locationUpdateSubject.send(location) // Send updated location
    }

    // Handle errors during location updates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
        self.locationError = error
    }

    // Get the current location as a publisher
    func getCurrentLocation() -> AnyPublisher<CLLocationCoordinate2D?, Never> {
        if let location = locationManager.location?.coordinate {
            return Just(location).eraseToAnyPublisher()
        } else {
            locationManager.requestLocation()
            return locationUpdateSubject.eraseToAnyPublisher() // Return publisher for location updates
        }
    }
}
