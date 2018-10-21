//
//  HeaderCollectionReusableView.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit
import Alamofire

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var postCount: UILabel!
    
    
    var user:User? {
        didSet{
            updateInfo()
        }
    }
    
    func updateInfo(){
        self.nameLabel.text = user!.username
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
        Helper.post.countPosts(userid: user!.uid!){
            (count) in
            self.postCount.text = "\(count)"
        }
        Helper.follow.countFollowers(userid: user!.uid!){
            (count) in
            self.followerCount.text = "\(count)"
        }
        Helper.follow.countFollowing(userid: user!.uid!){
            (count) in
            self.followingCount.text = "\(count)"
        }
            
        
    }
}
