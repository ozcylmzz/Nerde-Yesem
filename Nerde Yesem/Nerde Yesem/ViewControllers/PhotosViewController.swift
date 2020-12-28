//
//  PhotosViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 22.12.2020.
//

import UIKit
import Firebase

class PhotosViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var restaurant = [Restaurant]()
    var selectedRestaurant = Restaurant(id: "", name: "", address: "", latitude: "", longitude: "", averageCostForTwo: "", aggregateRating: "", img: "", webUrl: "", distance: "")
    
    let db = Firestore.firestore()
    var dbUserArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPhotos()
        
    }
    
    func loadPhotos() {
        
        db.collection("Photos")
            .addSnapshotListener { [self] (querySnapshot, error) in
            
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let user = data["user"] as? String,
                           let id = data["id"] as? String,
                           let name = data["name"] as? String,
                           let address = data["address"] as? String,
                           let latitude  = data["latitude"] as? String,
                           let longitude = data["longitude"] as? String,
                           let averageCostForTwo = data["averageCostForTwo"] as? String,
                           let aggregateRating = data["aggregateRating"] as? String,
                           let img = data["img"] as? String,
                           let webUrl = data["webUrl"] as? String,
                           let distance = data["distance"] as? String {
                            dbUserArray.append(user)
                            let restaurant = Restaurant.init(id: id, name: name, address: address, latitude: latitude, longitude: longitude, averageCostForTwo: averageCostForTwo, aggregateRating: aggregateRating , img: img, webUrl: webUrl, distance: distance)
                            self.restaurant.append(restaurant)
                            DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.restaurant.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        cell.senderLabel.text = dbUserArray[indexPath.row]
        var urlString = ""
        if self.restaurant[indexPath.row].getImg() != "" {
            urlString = self.restaurant[indexPath.row].getImg()

        } else {
            urlString = "https://blog.rahulbhutani.com/wp-content/uploads/2020/05/Screenshot-2018-12-16-at-21.06.29.png"
        }
        let url = URL(string: urlString)
        let data = try? Data(contentsOf: url!)
        cell.restaurantImage.image = UIImage(data: data!)
        cell.restaurantImage.image = resizeImage(image: cell.restaurantImage.image!, newWidth: CGFloat(350))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurant = self.restaurant[indexPath.row]
        performSegue(withIdentifier: "PhotoSelectedSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoSelectedSegue" {
            let toVC = segue.destination as! SelectedViewController
            toVC.selectedRestaurant = self.selectedRestaurant
        }
    }
    
    
    
}

class PhotosCell: UITableViewCell {
    
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
