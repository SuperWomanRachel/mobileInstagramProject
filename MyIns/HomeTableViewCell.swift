//
//  HomeTableViewCell.swift
//  MyIns
//
//  Created by Jingyuan Bi on 30/9/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var caption: UILabel!
    var post: Post? {
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        showUser(uid: (post?.uid)!)
        self.caption.text = post?.caption
        let photoImgurl = post?.photoURL
        Alamofire.request(photoImgurl!).responseImage { (response) in
            if let image = response.result.value {
                self.photo.image = image
            }
        }
    }
    
    func showUser(uid: String){
        _ = Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let user = User.transformUser(dict: dict, uid: uid)
                self.username.text = user.username
                if user.imageUserURL == nil {
                    self.profileImage.image = UIImage(named: "profile_signUp")
                }else{
                let userImgurl = user.imageUserURL
                Alamofire.request(userImgurl!).responseImage { (response) in
                    if let image = response.result.value {
                        self.profileImage.image = image
                    }
                    }
                }
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
}
