//
//  FollowingActivityTableViewCell.swift
//  MyIns
//
//  Created by tq on 2018/10/17.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class FollowingActivityTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var photo: UIImageView!
    
    var notification: Notification?{
        didSet{
            updateView()
        }
    }
    var user: User?{
        didSet{
            setupUser()
        }
    }
    
    func updateView(){
        
    }

    func setupUser(){
        usernameLabel.text = "ytttttt"
        if let photoUrlString = user?.imageUserURL{
            let photoUrl = URL(string: photoUrlString)
            profileImage.af_setImage(withURL: photoUrl!)
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
