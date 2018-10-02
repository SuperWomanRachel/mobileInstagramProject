//
//  HomeTableViewController.swift
//  MyIns
//
//  Created by Jingyuan Bi on 30/9/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GeoFire

class HomeTableViewController: UITableViewController, CLLocationManagerDelegate {


    var locationManager = CLLocationManager() //location
    var myLocation: CLLocation?
    @IBOutlet var homeTableView: UITableView!
    var posts = [Post]()
//    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        startUseLocation()
        loadPosts()
        
    }
    func loadPosts(){
        _ = Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let post = Post.transformPost(dict: dict, postID: snapshot.key)
//                self.fetchUser(uid: post.uid!)
                self.posts.append(post)
                if self.posts.count>1 {
                self.posts.sort { (this: Post, that: Post) -> Bool in
                    let thisTime = this.timestamp!
                    let thatTime = that.timestamp!
                    if thisTime != thatTime {
                        return thisTime > thatTime
                    }else{
                        let currentLocation = self.myLocation
                        let thisCoor = CLLocation(latitude: this.latitude!, longitude: this.longitude!)
                        let thisMeters = thisCoor.distance(from: currentLocation!)
                        let thatCoor = CLLocation(latitude: that.latitude!, longitude: that.longitude!)
                        let thatMeters = thatCoor.distance(from: currentLocation!)
                        return thisMeters < thatMeters
                    }
                    }
                }
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            //            print(location.coordinate) //print out the coordinates of your location
            //            self.myLocation = location
            self.myLocation = location
            
        }
    }
    
    fileprivate func startUseLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("allowed to use location")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.post = posts[indexPath.row]

        return cell
    }
    


}
