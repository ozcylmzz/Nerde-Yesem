//
//  LocationViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 9.12.2020.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var restaurantService = RestaurantService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted || status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantViewController") as! RestaurantViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat: String = location.coordinate.latitude.description
            let lon: String = location.coordinate.longitude.description
            print(lat)
            print(lon)
//            restaurantService.fetchData(_latitute: lat, _longitude: lon)
            restaurantService.fetchData(_latitute: "41.01", _longitude: "28.97")
        }
    }
}
