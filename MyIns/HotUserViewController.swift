//
//  HotUserViewController.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class HotUserViewController: UIViewController {
    var users:[User] = []
    var username:[String] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getHotUser()
        // Do any additional setup after loading the view.
    }
    
    
    func getHotUser(){
        Helper.post.observeTopPosts(completion:{
            (post) in
            let userid = post.uid
            if self.username.count < 10{
                if self.username.contains(userid!) == false{
                    self.username.append(userid!)
                    Helper.user.observeUser(withId: userid!, completion: {
                        (user) in
                            self.ifFollowing(uid: userid!, completed: {
                                value in
                                user.isFollowing = value
                                    if value==false && user.uid != Helper.user.CURRENT_USER?.uid{
                                        self.users.append(user)
                                        //self.username.append(user.uid!)
                                        self.tableView.reloadData()
                                    }
                            })
                    })
                }
            }
        })
    }
        
    
    func ifFollowing(uid:String, completed: @escaping (Bool)->Void){
        Helper.follow.ifFollowing(userId: uid, completed: completed)
    }
    

}

extension HotUserViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverUserTableViewCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
}
