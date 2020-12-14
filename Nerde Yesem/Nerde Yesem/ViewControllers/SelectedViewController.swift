//
//  SelectedViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 14.12.2020.
//

import UIKit
import MapKit

class SelectedViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedRestaurant = Restaurant(name: "", address: "", averageCostForTwo: "", aggregateRating: "", img: "")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        priceLabel.text = "Average Cost For Two : " + selectedRestaurant.getAverageCostForTwo()
        hoursLabel.text = "Unknown"
        addressLabel.text = selectedRestaurant.getAddress()
        ratingLabel.text = selectedRestaurant.getAggregateRating()
        var urlString = ""
        if selectedRestaurant.getImg() != "" {
            urlString = selectedRestaurant.getImg()
            
        } else {
            urlString = "https://blog.rahulbhutani.com/wp-content/uploads/2020/05/Screenshot-2018-12-16-at-21.06.29.png"
        }
        let url = URL(string: urlString)
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        
    }
    
}
