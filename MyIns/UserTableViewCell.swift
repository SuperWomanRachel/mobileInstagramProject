//
//  UserTableViewCell.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit
import Alamofire

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user:User? {
        didSet{
            updateUser()
        }
    }
    
    func updateUser(){
        nameLabel.text = user?.username
        if user!.imageUserURL == nil {
            self.profileImg.image = UIImage(named: "profile_signUp")
        }else{
            let userImgurl = user!.imageUserURL
            Alamofire.request(userImgurl!).responseImage { (response) in
                if let image = response.result.value {
                    self.profileImg.image = image
                }
            }
        }
        
        if user!.uid == Helper.user.CURRENT_USER?.uid{
            followButton.isEnabled = false
        }
        else{
        if user!.isFollowing!{
            setUnfollowButton()
        }
        else{
            setFollowButton()
        }
        }
    }
    
    func setFollowButton(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        //followButton.layer.cornerRadius = 5
        //followButton.clipsToBounds = true
        followButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
  
        followButton.setTitle("Follow+", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func setUnfollowButton(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        //followButton.layer.cornerRadius = 5
        //followButton.clipsToBounds = true
        followButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        followButton.backgroundColor = UIColor.clear
        followButton.setTitle("Following", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.unfollowAction), for: UIControlEvents.touchUpInside)
    }
    
    //only allow one action
    @objc func followAction(){
        if user!.isFollowing! == false{
            Helper.follow.followAction(withId: user!.uid!)
            setUnfollowButton()
            user!.isFollowing = true
            
        }
    }
    
    @objc func unfollowAction(){
        if user!.isFollowing!{
            Helper.follow.unfollowAction(withId: user!.uid!)
            setFollowButton()
            user!.isFollowing = false
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
