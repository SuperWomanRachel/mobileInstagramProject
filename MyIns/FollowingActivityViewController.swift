//
//  FollowingActivityViewController.swift
//  MyIns
//
//  Created by tq on 2018/10/17.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class FollowingActivityViewController: UIViewController {

    
    @IBOutlet weak var followingTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension FollowingActivityViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingActivityTableViewCell", for: indexPath) as! FollowingActivityTableViewCell
        let image = UIImage(named: "liked")
        cell.usernameLabel.text = "following"
        cell.profileImage.image = image
        //image = UIImage(named: "profile_signUp")
        //cell.profileImage = UIImageView(image: image)
        
        return cell
    }
    
    
}
