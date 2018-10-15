//
//  likesTableViewCell.swift
//  MyIns
//
//  Created by Jingyuan Bi on 3/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import UIKit
import Alamofire

class likesTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var user: User?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        self.username.text = user?.username
        let userImgurl = user?.imageUserURL
        if userImgurl != nil{
            Alamofire.request(userImgurl!).responseImage { (response) in
                if let image = response.result.value {
                    self.profileImage.image = image
                }
            }
        }else{
            self.profileImage.image = UIImage(named: "profile_signUp")
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
