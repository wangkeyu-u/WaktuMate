import CoreLocation
import Foundation

final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var location: CLLocation?
    @Published var heading: CLHeading?
    @Published var message: String?

    private let manager = CLLocationManager()

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.headingFilter = 2
    }

    var canUseCompass: Bool {
        CLLocationManager.headingAvailable()
    }

    var currentHeadingDegrees: Double? {
        guard let heading else {
            return nil
        }

        let trueHeading = heading.trueHeading
        return trueHeading >= 0 ? trueHeading : heading.magneticHeading
    }

    var qiblaBearingDegrees: Double? {
        guard let coordinate = location?.coordinate else {
            return nil
        }

        return Self.bearing(
            from: coordinate,
            to: CLLocationCoordinate2D(latitude: 21.4225, longitude: 39.8262)
        )
    }

    var qiblaOffsetDegrees: Double? {
        guard let heading = currentHeadingDegrees,
              let qibla = qiblaBearingDegrees else {
            return nil
        }

        return qibla - heading
    }

    func requestLocation() {
        message = nil

        switch authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            message = "Location permission is disabled. You can still open Google Maps with a nearby search."
        @unknown default:
            message = "Location permission is unavailable."
        }
    }

    func startCompass() {
        requestLocation()

        guard canUseCompass else {
            message = "Compass heading is not available on this device."
            return
        }

        manager.startUpdatingHeading()
    }

    func stopCompass() {
        manager.stopUpdatingHeading()
    }

    func googleMapsURL(for query: String) -> URL? {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query

        if let coordinate = location?.coordinate {
            return URL(string: "comgooglemaps://?q=\(encodedQuery)&center=\(coordinate.latitude),\(coordinate.longitude)&zoom=14")
        } else {
            return URL(string: "comgooglemaps://?q=\(encodedQuery)%20near%20me")
        }
    }

    func googleMapsWebURL(for query: String) -> URL? {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query

        if let coordinate = location?.coordinate {
            return URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)&center=\(coordinate.latitude),\(coordinate.longitude)")
        } else {
            return URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedQuery)%20near%20me")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            self?.authorizationStatus = manager.authorizationStatus

            if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
                manager.requestLocation()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async { [weak self] in
            self?.location = locations.last
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async { [weak self] in
            self?.heading = newHeading
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.message = error.localizedDescription
        }
    }

    private static func bearing(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> Double {
        let sourceLatitude = source.latitude.degreesToRadians
        let sourceLongitude = source.longitude.degreesToRadians
        let destinationLatitude = destination.latitude.degreesToRadians
        let destinationLongitude = destination.longitude.degreesToRadians
        let longitudeDelta = destinationLongitude - sourceLongitude

        let y = sin(longitudeDelta) * cos(destinationLatitude)
        let x = cos(sourceLatitude) * sin(destinationLatitude) - sin(sourceLatitude) * cos(destinationLatitude) * cos(longitudeDelta)
        let bearing = atan2(y, x).radiansToDegrees

        return (bearing + 360).truncatingRemainder(dividingBy: 360)
    }
}

private extension Double {
    var degreesToRadians: Double {
        self * .pi / 180
    }

    var radiansToDegrees: Double {
        self * 180 / .pi
    }
}
