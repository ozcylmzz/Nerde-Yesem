//
//  LocationService.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 11.12.2020.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate  {

    let LocationKey = "LocationKey"
    let restaurantService = RestaurantService()
    let locManager : CLLocationManager = CLLocationManager()
    var updatedLocation : [String] = []

    override init() {
        super.init()
        locManager.delegate = self
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            self.locManager.startMonitoringSignificantLocationChanges()
            self.locManager.pausesLocationUpdatesAutomatically = false
         case .authorizedWhenInUse:
            print("I got when in Use")
            self.locManager.startMonitoringSignificantLocationChanges()
        case .notDetermined:
            print("not determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        @unknown default:
            print("error")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat: String = location.coordinate.latitude.description
            let lon: String = location.coordinate.longitude.description
            print(lat)
            print(lon)
            let currentLoc = "\(lat) \(lon)"
            self.updatedLocation.append(currentLoc)
            print("Did get Update loation")
            restaurantService.fetchData(_latitute: "41.01", _longitude: "28.97")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
