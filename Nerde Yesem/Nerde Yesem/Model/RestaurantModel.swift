//
//  RestaurantModel.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 10.12.2020.
//

class Restaurant {
    
    let id: String
    let name: String
    let address: String
    let latitude: String
    let longitude: String
    let averageCostForTwo: String
    let aggregateRating: String
    let img: String
    let webUrl: String
    
    init(id: String, name: String, address: String, latitude: String, longitude: String, averageCostForTwo: String, aggregateRating: String, img: String, webUrl: String) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.averageCostForTwo = averageCostForTwo
        self.aggregateRating = aggregateRating
        self.img = img
        self.webUrl = webUrl
    }
    
    func getId() -> String {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getAddress() -> String {
        return address
    }
    
    func getLatitude() -> String {
        return latitude
    }
    
    func getLongitude() -> String {
        return longitude
    }
    
    func getAverageCostForTwo() -> String {
        return averageCostForTwo
    }
    
    func getAggregateRating() -> String {
        return aggregateRating
    }
    
    func getImg() -> String {
        return img
    }
    
    func getWebUrl() -> String {
        return webUrl
    }
}
