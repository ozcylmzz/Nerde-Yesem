//
//  LocationViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 9.12.2020.
//

import UIKit
import CoreLocation
import LocalAuthentication

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var restaurants = [Restaurant]()
    var result: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization()
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.pausesLocationUpdatesAutomatically = false
         case .authorizedWhenInUse:
            print("I got when in Use")
            locationManager.startMonitoringSignificantLocationChanges()
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
            print("Did get Update loation")
//            fetchData(_latitute: "41.01", _longitude: "28.97")
            fetchData(_latitute: lat, _longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func fetchData(_latitute: String, _longitude: String) {
        
        restaurants.removeAll()
        
        let userKey = "243455cc454bcf8d2e60d90e4c074d19"
        let urlString = "https://developers.zomato.com/api/v2.1/geocode?lat="+_latitute+"&lon="+_longitude
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue(userKey, forHTTPHeaderField: "user-key")
//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: url) { (data, response, error) in
        URLSession.shared.dataTask(with: request){ [self] (data, response, error) in
            if error != nil {
                
                print("Error in dataTask")
            
            } else if (data != nil) {
                
                let jsonResponse = try? (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any>)
                
                let nearby_restaurant = (jsonResponse?["nearby_restaurants"] as! Array<Dictionary<String,Any>>)
//                let userRating = (jsonResponse?["user_rating"] as! Dictionary<String,Any>)
//                let location = (jsonResponse?["location"] as! Dictionary<String,Any>)
                
                for i in 0...nearby_restaurant.count-1{
                    
                    let nearRestaurant = (nearby_restaurant[i]["restaurant"]) as! Dictionary<String,Any>
                    let userRating = (nearRestaurant["user_rating"] as! Dictionary<String,Any>)
                    let location = (nearRestaurant["location"] as! Dictionary<String,Any>)
                    
                    let webUrl = nearRestaurant["url"] as! String
                    let name = nearRestaurant["name"] as! String
                    let address = location["address"] as! String
                    let averageCostForTwo = nearRestaurant["average_cost_for_two"] as! Int
                    let currency = nearRestaurant["currency"] as! String
                    let aggregateRating = userRating["aggregate_rating"] as! String
                    let img = nearRestaurant["featured_image"] as! String
                    
                    let averageCost = averageCostForTwo.description + currency
                    print(name, img, address, aggregateRating, averageCost, webUrl)
                    
                    let restaurants = Restaurant.init(name: name, address: address, averageCostForTwo: averageCost, aggregateRating: aggregateRating , img: img, webUrl: webUrl)
                    
                    self.restaurants.append(restaurants)
                    
                }
                DispatchQueue.main.async {
                   self.dismiss(animated: false, completion: nil)
                }
            }
        }.resume()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantViewSegue" {
            let toVC = segue.destination as! RestaurantViewController
            toVC.restaurant = self.restaurants
        }
    }
    
    @IBAction func showButton(_ sender: UIButton) {
        if restaurants.count > 0 {
            self.performSegue(withIdentifier: "RestaurantViewSegue", sender: self)
        } 
    }
}
