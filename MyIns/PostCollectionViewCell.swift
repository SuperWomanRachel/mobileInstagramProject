//
//  PostCollectionViewCell.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit
import Alamofire

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postpic: UIImageView!
    
    var post:Post?{
        didSet{
            loadAllPosts()
        }
    }
    
    func loadAllPosts(){
        if post!.photoURL == nil {
            self.postpic.image = UIImage(named: "profile_signUp")
        }else{
            let photourl = post!.photoURL
            Alamofire.request(photourl!).responseImage { (response) in
                if let image = response.result.value {
                    self.postpic.image = image
                }
            }
        }
    }
    
}
