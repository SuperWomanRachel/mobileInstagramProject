//
//  FollowingActivityViewController.swift
//  MyIns
//
//  Created by tq on 2018/10/17.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit
import FirebaseAuth

class FollowingActivityViewController: UIViewController {

    
    @IBOutlet weak var followingTableView: UITableView!
    var notifications = [Notification]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load following view")

        loadActivity()
    }
    
    
    func loadActivity(){
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        print("##############\n#########\n#######")
        print(currentUser.uid)
        NotificationService.observeNotification(withId: currentUser.uid,completion: {
            notification in
            guard let uid = notification.from else{
                return
            }
            self.fetchUser(uid: uid, completion: {
                self.notifications.insert(notification, at: 0)
                self.followingTableView.reloadData()
            })
        })
        
    }
    
    func fetchUser(uid: String, completion: @escaping ()->Void){
        NotificationService.observeUser(withId: uid, completion: {
            user in
            self.users.insert(user, at: 0)
            completion()
        })
        
    }
    

}

extension FollowingActivityViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingActivityTableViewCell", for: indexPath) as! FollowingActivityTableViewCell
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        cell.notification = notification
        cell.user = user
//        let image = UIImage(named: "liked")
//        cell.usernameLabel.text = "following"
//        cell.profileImage.image = image
//        //image = UIImage(named: "profile_signUp")
//        //cell.profileImage = UIImageView(image: image)
        
        return cell
    }
    
    
}
