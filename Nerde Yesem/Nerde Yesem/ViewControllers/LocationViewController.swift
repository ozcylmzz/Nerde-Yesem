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
        navigationItem.hidesBackButton = true
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
            print("Did get Update location")
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
        URLSession.shared.dataTask(with: request){ [self] (data, response, error) in
            if error != nil {
                
                print("Error in dataTask")
            
            } else if (data != nil) {
                
                let jsonResponse = try? (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any>)
                
                let nearby_restaurant = (jsonResponse?["nearby_restaurants"] as! Array<Dictionary<String,Any>>)
                
                for i in 0...nearby_restaurant.count-1{
                    
                    let nearRestaurant = (nearby_restaurant[i]["restaurant"]) as! Dictionary<String,Any>
                    let userRating = (nearRestaurant["user_rating"] as! Dictionary<String,Any>)
                    let location = (nearRestaurant["location"] as! Dictionary<String,Any>)
                    
                    let id = nearRestaurant["id"] as! String
                    let name = nearRestaurant["name"] as! String
                    let address = location["address"] as! String
                    let latitude = location["latitude"] as! String
                    let longitude = location["longitude"] as! String
                    let averageCostForTwo = nearRestaurant["average_cost_for_two"] as! Int
                    let currency = nearRestaurant["currency"] as! String
                    let aggregateRating = userRating["aggregate_rating"] as! String
                    let img = nearRestaurant["featured_image"] as! String
                    let webUrl = nearRestaurant["url"] as! String
                    
                    let averageCost = averageCostForTwo.description + currency
                    print(id, name, img, address, latitude, longitude, aggregateRating, averageCost, webUrl)
                    
                    let myLocation = CLLocation(latitude: Double(_latitute)!, longitude: Double(_longitude)!)
                    let myBuddysLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                    var distance = myLocation.distance(from: myBuddysLocation) / 1000
                    distance = (distance*100).rounded()/100
                    let distanceString = distance.description
                    print("Distance: \(distanceString)")
                    
                    let restaurants = Restaurant.init(id: id, name: name, address: address, latitude: latitude, longitude: longitude, averageCostForTwo: averageCost, aggregateRating: aggregateRating , img: img, webUrl: webUrl, distance: distanceString)
                    
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
