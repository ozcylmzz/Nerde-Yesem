//
//  FavouritesViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 20.12.2020.
//

import UIKit
import Firebase

class FavouritesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var restaurant = [Restaurant]()
    var selectedRestaurant = Restaurant(id: "", name: "", address: "", latitude: "", longitude: "", averageCostForTwo: "", aggregateRating: "", img: "", webUrl: "", distance: "")
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadRestaurants()
    }
    
    func loadRestaurants() {
        
        let currentUser = Auth.auth().currentUser?.email
        db.collection("Favourites")
//            .order()
            .addSnapshotListener { (querySnapshot, error) in
            
            
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
                            if currentUser == user {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCell", for: indexPath) as! FavouritesCell
        cell.restaurantName.text = self.restaurant[indexPath.row].getName()
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
        cell.restaurantDistance.text = self.restaurant[indexPath.row].getDistance()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurant = self.restaurant[indexPath.row]
        performSegue(withIdentifier: "FavouriteSelectedSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavouriteSelectedSegue" {
            let toVC = segue.destination as! SelectedViewController
            toVC.selectedRestaurant = self.selectedRestaurant
        }
    }

}

class FavouritesCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
