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
    @IBOutlet weak var uploadLabel: UILabel!
    
    let db = Firestore.firestore()
    
    var selectedRestaurant = Restaurant(id: "", name: "", address: "", latitude: "", longitude: "", averageCostForTwo: "", aggregateRating: "", img: "", webUrl: "", distance: "")

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
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: Double(selectedRestaurant.getLatitude())!, longitude: Double(selectedRestaurant.getLongitude())!)
        annotation.coordinate = centerCoordinate
        annotation.title = selectedRestaurant.getName()
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta:
        0.01)
        let region = MKCoordinateRegion.init(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        isLiked()
        isUploaded()
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
    
    func isUploaded() {
        
        let docRef = db.collection("Photos").whereField("id", isEqualTo: selectedRestaurant.getId()).limit(to: 1)
        docRef.getDocuments { (querysnapshot, error) in
            if error != nil {
                print("Document Error: ", error!)
            } else {
                if let doc = querysnapshot?.documents, !doc.isEmpty {
                    print("Uploaded")
                    self.uploadLabel.text = "Delete Photo on Cloud"
                } else {
                    print("Not uploaded")
                    self.uploadLabel.text = "Upload Photo to Cloud"
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
                    "webUrl": selectedRestaurant.getWebUrl(),
                    "distance": selectedRestaurant.getDistance()
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
                    print("please install WhatsApp")
                    let ac = UIAlertController(title: "Failed", message: "Please install WhatsApp", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }
    
    @IBAction func openWithSafari(_ sender: UIButton) {
        
        var url: String = selectedRestaurant.getWebUrl()
        let webUrl = url.split(separator: "?")
        url = webUrl[0].description
        
        
        if let requestUrl = URL(string: "url") {
             UIApplication.shared.open(requestUrl as URL)
        } else {
            print("failed safari")
            let ac = UIAlertController(title: "Failed", message: "Url couldn't open with Safari", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        
    }
    
    @IBAction func uploadTap(_ sender: UIButton) {
    
        if uploadLabel.text == "Delete Photo on Cloud" {
            print("it's already added to database.")
            db.collection("Photos").whereField("id", isEqualTo: selectedRestaurant.getId()).getDocuments { (querySnapshot, error) in
                if error != nil {
                    print(error)
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }

                }
            }
            self.uploadLabel.text = "Upload Photo to Cloud"
        } else {
            print("it's not exist in database.")
            if let user = Auth.auth().currentUser?.email {
                db.collection("Photos").addDocument(data: [
                    "user": user,
                    "id": selectedRestaurant.getId(),
                    "name": selectedRestaurant.getName(),
                    "address": selectedRestaurant.getAddress(),
                    "latitude": selectedRestaurant.getLatitude(),
                    "longitude": selectedRestaurant.getLongitude(),
                    "averageCostForTwo": selectedRestaurant.getAverageCostForTwo(),
                    "aggregateRating": selectedRestaurant.getAggregateRating(),
                    "img": selectedRestaurant.getImg(),
                    "webUrl": selectedRestaurant.getWebUrl(),
                    "distance": selectedRestaurant.getDistance()
                ]) { (error) in
                    if let e = error {
                        print("İssue on saving data to firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                        self.uploadLabel.text = "Delete Photo on Cloud"
                    }
                }
            }
            
        }
    
    }
}
