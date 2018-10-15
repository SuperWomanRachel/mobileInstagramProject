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
import FirebaseAuth


class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var caption: UILabel!

    @IBOutlet weak var likeBtn: UIImageView!
    @IBOutlet weak var commentBtn: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var showUserListLabel: UILabel!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var viewAllLikesBtn: UIButton!
    
    var homeTableView: HomeTableViewController?

    var post: Post? {
        didSet{
            updateView()
        }
    }

//    var users = [User]()
    
    
    //update cell
    func updateView(){
        showUser(uid: (post?.uid)!)

        self.caption.text = post?.caption
        let photoImgurl = post?.photoURL
        Alamofire.request(photoImgurl!).responseImage { (response) in
            if let image = response.result.value {
                self.photo.image = image
            }
        }

        loadLikes()
    }
    
    func loadLikes() {
        //load like
        Database.database().reference().child("posts").child((post?.postID)!).observeSingleEvent(of:.value) {(snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, postID: snapshot.key)
                let isLike = post.isLike!
                if isLike {
                    self.likeBtn.image = UIImage(named: "liked")
                }else{
                    self.likeBtn.image = UIImage(named: "like")
                }
                self.showUserListLabel.text = "be the first one like this post!"
                self.viewAllLikesBtn.isEnabled = false
                self.viewAllLikesBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                guard let likes = post.likes else{ return }
                if likes.count == 0 {
                    self.viewAllLikesBtn.isEnabled = false
                    self.viewAllLikesBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                    self.showUserListLabel.text = "be the first one like this post!"
                }else{
                    self.viewAllLikesBtn.isEnabled = true
                    self.viewAllLikesBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
                    self.showUserListLabel.text = ""
                    for key in likes.keys {
                        self.fetchUsers(uid: key, completion: { (user) in
                            self.showUserListLabel.text?.append(user.username!)
                            self.showUserListLabel.text?.append(",")
                        })
                    }
                    self.showUserListLabel.text?.append("like(s) this post:\n  ")
                }
            }
        }
    }
    //update user
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
    

    
    //load users who like this post
    func fetchUsers(uid: String,completion : @escaping(User) -> Void){
        _ = Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let user = User.transformUser(dict: dict, uid: uid)
                //                self.users.append(user)
//                print(user.email!)
                completion(user)
            }
        })
    }
    
    @IBAction func showUserList(_ sender: Any) {
        if let postID = post?.postID {
//            print(postID)
            homeTableView?.performSegue(withIdentifier: "LikesListSegue", sender: postID)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //enable the comment image btn
        let tapGestureForComment = UITapGestureRecognizer(target: self, action: #selector(commentImageViewClicked))
        commentBtn.addGestureRecognizer(tapGestureForComment)
        commentBtn.isUserInteractionEnabled = true
        //enable the like image btn
        let tapGestureForLike = UITapGestureRecognizer(target: self, action: #selector(LikeImageViewClicked))
        likeBtn.addGestureRecognizer(tapGestureForLike)
        likeBtn.isUserInteractionEnabled = true
    }
    
    @objc func LikeImageViewClicked(){
//        print("like btn clicked")
        let currentUserID = Auth.auth().currentUser?.uid
        let likesRef = Database.database().reference().child("posts").child((post?.postID)!).child("likes")
        if self.likeBtn.image == UIImage(named: "like") {
            likesRef.child(currentUserID!).setValue(true)
            self.likeBtn.image = UIImage(named: "liked")
        }else{
            likesRef.child(currentUserID!).removeValue()
            self.likeBtn.image = UIImage(named: "like")
        }
        loadLikes()

    }

    @objc func commentImageViewClicked(){
        if let postID = post?.postID {
            homeTableView?.performSegue(withIdentifier: "writeCommentSegue", sender: postID)
        }
    }
    



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }



}
