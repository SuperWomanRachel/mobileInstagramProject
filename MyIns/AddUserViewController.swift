//
//  AddUserViewController.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var users:[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllUsers()
        // Do any additional setup after loading the view.
    }
    
    func loadAllUsers(){
        Helper.user.observeAllUsers{(user) in
            self.ifFollowing(uid: user.uid!, completed: {
                (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })

        }
        
    }
    
    func ifFollowing(uid:String, completed: @escaping (Bool)->Void){
        Helper.follow.ifFollowing(userId: uid, completed: completed)
    }

}

extension AddUserViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
}
