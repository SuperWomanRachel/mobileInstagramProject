//
//  CommentTableViewCell.swift
//  MyIns
//
//  Created by Jingyuan Bi on 3/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import UIKit
import Alamofire

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var username: UILabel!
    
    
    var comment: Comment?{
        didSet{
            updateComment()
        }
    }
    var user: User?{
        didSet{
            updateUserInfo()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateComment(){
        self.message.text = comment?.commentText
        self.timestamp.text = Config.timestampToDate(timeStamp: (comment?.timestamp)!)
    }
    
    func updateUserInfo(){
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
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
