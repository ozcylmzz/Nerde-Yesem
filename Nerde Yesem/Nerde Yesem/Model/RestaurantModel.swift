//
//  RestaurantModel.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 10.12.2020.
//

class Restaurant {
    
    let name: String
    let address: String
    let averageCostForTwo: String
    let aggregateRating: String
    let img: String
    let webUrl: String
    
    init(name: String, address: String, averageCostForTwo: String, aggregateRating: String, img: String, webUrl: String) {
        self.name = name
        self.address = address
        self.averageCostForTwo = averageCostForTwo
        self.aggregateRating = aggregateRating
        self.img = img
        self.webUrl = webUrl
    }
    
    func getName() -> String {
        return name
    }
    
    func getAddress() -> String {
        return address
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
