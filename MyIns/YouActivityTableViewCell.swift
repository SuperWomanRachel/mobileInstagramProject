//
//  YouActivityTableViewCell.swift
//  MyIns
//
//  Created by tq on 2018/10/17.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class YouActivityTableViewCell: UITableViewCell {

    
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
        
        ActivityHelper.updateView(notification: notification!, timeLabel: timeLabel, descriptionLabel: descriptionLabel, photo: photo)
    }
    
    func setupUser(){
        ActivityHelper.setupUser(user: user!, usernameLabel: usernameLabel, profileImage: profileImage)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
