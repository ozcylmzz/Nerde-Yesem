//
//  RestaurantViewController.swift
//  Nerde Yesem
//
//  Created by Özcan Yılmaz on 9.12.2020.
//

import UIKit


class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var restaurant = [Restaurant]()
    var selectedRestaurant = Restaurant(name: "", address: "", averageCostForTwo: "", aggregateRating: "", img: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurant = self.restaurant[indexPath.row]
        performSegue(withIdentifier: "SelectedViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectedViewSegue" {
            let toVC = segue.destination as! SelectedViewController
            toVC.selectedRestaurant = self.selectedRestaurant
        }
    }
    
}

class RestaurantCell: UITableViewCell {
    
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


