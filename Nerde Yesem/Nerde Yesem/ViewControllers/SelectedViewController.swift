//
//  SelectedViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 14.12.2020.
//

import UIKit
import MapKit
import Firebase

class SelectedViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var isLikedButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    var selectedRestaurant = Restaurant(id: "", name: "", address: "", latitude: "", longitude: "", averageCostForTwo: "", aggregateRating: "", img: "", webUrl: "")
    
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
        isLiked()
    }
    
    func isLiked() {
        
        let docRef = db.collection("Favourites").whereField("id", isEqualTo: selectedRestaurant.getId()).limit(to: 1)
        docRef.getDocuments { (querysnapshot, error) in
            if error != nil {
                print("Document Error: ", error!)
            } else {
                if let doc = querysnapshot?.documents, !doc.isEmpty {
                    print("Document is present.")
                    self.isLikedButton.title = "Liked"
                } else {
                    print("Document is not present.")
                    self.isLikedButton.title = "UnLiked"
                }
            }
        }

    }
    
    @IBAction func isLikedTap(_ sender: UIBarButtonItem) {
        
        if isLikedButton.title!.description == "Liked" {
            print("it's already added to database.")
            db.collection("Favourites").whereField("id", isEqualTo: selectedRestaurant.getId()).getDocuments { (querySnapshot, error) in
                if error != nil {
                    print(error)
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }

                }
            }
            self.isLikedButton.title = "UnLiked"
        } else {
            print("it's not exist in database.")
            if let user = Auth.auth().currentUser?.email {
                db.collection("Favourites").addDocument(data: [
                    "user": user,
                    "id": selectedRestaurant.getId(),
                    "name": selectedRestaurant.getName(),
                    "address": selectedRestaurant.getAddress(),
                    "latitude": selectedRestaurant.getLatitude(),
                    "longitude": selectedRestaurant.getLongitude(),
                    "averageCostForTwo": selectedRestaurant.getAverageCostForTwo(),
                    "aggregateRating": selectedRestaurant.getAggregateRating(),
                    "img": selectedRestaurant.getImg(),
                    "webUrl": selectedRestaurant.getWebUrl()
                ]) { (error) in
                    if let e = error {
                        print("İssue on saving data to firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                        self.isLikedButton.title = "Liked"
                    }
                }
            }
            
        }
        
        
    }
    
    @IBAction func shareWithWhatsApp(_ sender: UIButton) {
        
        var message = selectedRestaurant.getWebUrl()
        let webUrl = message.split(separator: "?")
        message = "I found a awesome restaurant, check it: " + webUrl[0].description
        let queryCharSet = NSCharacterSet.urlQueryAllowed
        
        if let escapedString = message.addingPercentEncoding(withAllowedCharacters: queryCharSet) {
            if let whatsappURL = URL(string: "whatsapp://send?text=\(escapedString)") {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: [: ], completionHandler: nil)
                } else {
                    debugPrint("please install WhatsApp")
                }
            }
        }
    }
    
}
