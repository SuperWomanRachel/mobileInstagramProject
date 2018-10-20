//
//  YouActivityViewController.swift
//  MyIns
//
//  Created by tq on 2018/10/17.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit
import FirebaseAuth
import MJRefresh

class YouActivityViewController: UIViewController {

    
    @IBOutlet weak var youTableView: UITableView!
    
    var notifications = [Notification]()
    var users = [User]()
    let header = MJRefreshHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("load YOU view")
        
        loadActivity()
        
        
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        self.youTableView.mj_header = header
    }
    
    @objc func headerRefresh(){
        print("header refresh")
        reloadActivity()
        self.youTableView.reloadData()
        self.youTableView.mj_header.endRefreshing()
    }
    
    func reloadActivity(){
        notifications.removeAll()
        users.removeAll()
        print("remove all users and notifications")
        loadActivity()
    }
    
    func loadActivity(){
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        NotificationService.observeMyNotification(withId: currentUser.uid,completion: {
            notification in
            guard let uid = notification.from else{
                return
            }
            self.fetchUser(uid: uid, completion: {
                self.notifications.insert(notification, at: 0)
                self.youTableView.reloadData()
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


extension YouActivityViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YouActivityTableViewCell", for: indexPath) as! YouActivityTableViewCell
        
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        
        cell.notification = notification
        cell.user = user
        return cell
       
    }
    
    
}
