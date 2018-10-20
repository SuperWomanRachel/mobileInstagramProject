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
import FirebaseAuth

class HomeTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    // 1. create locationManager
    var locationManager = CLLocationManager() //location
    var myLocation: CLLocation?
    @IBOutlet var homeTableView: UITableView!
    var posts = [Post]()
    var swipeImage = UIImage()
    //    var followings = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2. setup locationManager
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        
        homeTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        startUseLocation()
        getCurrentUserFeed()
        //        loadPosts()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            ProgressHUD.showError("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    // updated 201810161651
    func getCurrentUserFeed(){
        let currentUserID = Auth.auth().currentUser?.uid
        Database.database().reference().child("feeds").child(currentUserID!).observe(.childAdded, with: { (snapshot) in
            Database.database().reference().child("posts").child(snapshot.key).observeSingleEvent(of: .value, with: { (pSnapshot) in
                
                //copy from loadPosts()
                if let dict = pSnapshot.value as? [String:Any] {
                    let post = Post.transformPost(dict: dict, postID: pSnapshot.key)
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
                //copy end
            })
        })
    }
    
    
    //    func loadPosts(){
    //
    //        _ = Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
    //            if let dict = snapshot.value as? [String:Any] {
    //                let post = Post.transformPost(dict: dict, postID: snapshot.key)
    ////                self.fetchUser(uid: post.uid!)
    //                self.posts.append(post)
    //                if self.posts.count>1 {
    //                self.posts.sort { (this: Post, that: Post) -> Bool in
    //                    let thisTime = this.timestamp!
    //                    let thatTime = that.timestamp!
    //                    if thisTime != thatTime {
    //                        return thisTime > thatTime
    //                    }else{
    //                        let currentLocation = self.myLocation
    //                        let thisCoor = CLLocation(latitude: this.latitude!, longitude: this.longitude!)
    //                        let thisMeters = thisCoor.distance(from: currentLocation!)
    //                        let thatCoor = CLLocation(latitude: that.latitude!, longitude: that.longitude!)
    //                        let thatMeters = thatCoor.distance(from: currentLocation!)
    //                        return thisMeters < thatMeters
    //                    }
    //                    }
    //                }
    //                print(self.posts)
    //
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    
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
    
    
    //prepare: for sending the postid to comment view controller and like view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "writeCommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postID = sender as! String
            commentVC.postID = postID
        }
        else if segue.identifier == "LikesListSegue"{
            let commentVC = segue.destination as! LikesViewController
            let postID = sender as! String
            commentVC.postID = postID
        }else if segue.identifier == "share" {
            let connectViewController = segue.destination as! ConnectViewController
            connectViewController.imageToSwipe = self.swipeImage
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.post = posts[indexPath.row]
        
        cell.homeTableView = self
        
        
        
        return cell
    }
    
    
    
}
