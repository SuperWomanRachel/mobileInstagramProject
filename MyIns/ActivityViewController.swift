//
//  ActivityViewController.swift
//  MyIns
//
//  Created by tq on 2018/10/15.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}


extension ActivityViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        
        cell.usernameLabel.text = "helen"
        //image = UIImage(named: "profile_signUp")
        //cell.profileImage = UIImageView(image: image)
        
        return cell
    }
    
    
}
