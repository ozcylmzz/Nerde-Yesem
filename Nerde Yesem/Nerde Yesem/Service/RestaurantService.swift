//
//  RestaurantService.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 10.12.2020.
//

import Foundation

class RestaurantService {
    
    static var RestaurantData: Array<Restaurant> = []
    
    func fetchData(_latitute: String, _longitude: String) {
        
        RestaurantService.RestaurantData.removeAll()
        
        let userKey = "243455cc454bcf8d2e60d90e4c074d19"
        let urlString = "https://developers.zomato.com/api/v2.1/geocode?lat="+_latitute+"&lon="+_longitude
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.addValue(userKey, forHTTPHeaderField: "user-key")
//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: url) { (data, response, error) in
        URLSession.shared.dataTask(with: request){ (data, response, error) in
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
                    
                    let name = nearRestaurant["name"] as! String
                    let address = location["address"] as! String
                    let averageCostForTwo = nearRestaurant["average_cost_for_two"] as! Int
                    let currency = nearRestaurant["currency"] as! String
                    let aggregateRating = userRating["aggregate_rating"] as! String
                    let img = nearRestaurant["photos_url"] as! String
                    
                    let averageCost = averageCostForTwo.description + currency
                    print(name, img, address, aggregateRating, averageCost)
                    
                    let restaurants = Restaurant.init(name: name, address: address, averageCostForTwo: averageCost, aggregateRating: aggregateRating , img: img)
                    
                    RestaurantService.RestaurantData.append(restaurants)
                }
            }
        }.resume()
        
    }
}
