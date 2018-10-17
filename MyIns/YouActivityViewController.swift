//
//  YouActivityViewController.swift
//  MyIns
//
//  Created by tq on 2018/10/17.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class YouActivityViewController: UIViewController {

    
    @IBOutlet weak var youTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}


extension YouActivityViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YouActivityTableViewCell", for: indexPath) as! YouActivityTableViewCell
        
        cell.usernameLabel.text = "You"
        let image = UIImage(named: "profile_signUp")
        cell.profileImage.image = image
        //image = UIImage(named: "profile_signUp")
        //cell.profileImage = UIImageView(image: image)
        
        return cell
    }
    
    
}
