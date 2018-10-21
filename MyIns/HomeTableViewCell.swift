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
        loadLikes(post: post!)
        Database.database().reference().child("posts").child((post?.postID)!).observe(.childChanged) { (snapshot) in
            if let likes = snapshot.value as? [String: Any]{
                self.updateLikeCount(post: self.post!)
            }
        }
        
    }
    
    func loadLikes(post: Post) {
        //load like
        Database.database().reference().child("posts").child((post.postID)!).observeSingleEvent(of:.value) {(snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, postID: snapshot.key)
                let isLike = post.isLike!
                if isLike {
                    self.likeBtn.image = UIImage(named: "liked")
                }else{
                    self.likeBtn.image = UIImage(named: "like")
                }
                if post.likeCount != nil {
//                    let count = post.likeCount!
                    self.updateLikeCount(post: post)
                }
            }
        }
    }
    
    func updateLikeCount(post: Post){
        print("________________")
        print("update like count")
        print(post.caption)
        if post.likeCount != 0  {
            let count = post.likeCount!
            self.viewAllLikesBtn.isEnabled = true
            self.viewAllLikesBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
            self.showUserListLabel.text = "\(count) like(s)"
        }else{
            self.viewAllLikesBtn.isEnabled = false
            self.viewAllLikesBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.showUserListLabel.text = "be the first one like this post!"
        }
    }
    
    
    func incrementLikes(forRef ref: DatabaseReference){
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                //                print("value 1 : \(String(describing: currentData.value))")
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unstar the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                    
                } else {
                    // Star the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            //            print("value 2 : \(String(describing: snapshot?.value))")
            if let dict = snapshot?.value as? [String: Any]{
                let post = Post.transformPost(dict: dict, postID: (snapshot?.key)!)
                self.loadLikes(post: post)
                self.updateLikeCount(post: post)
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
        print("like imaage view clicked")
        print(post?.caption)
        let currentUserID = Auth.auth().currentUser?.uid
        var postRef = Database.database().reference().child("posts").child((post?.postID)!)
        //        let likesRef = postRef.child("likes")
        if self.likeBtn.image == UIImage(named: "like") {
            //            likesRef.child(currentUserID!).setValue(true)
            
//            NotificationService.uploadActivity(currentUserID: currentUserID!, post: post!,type: "like")
            
            self.likeBtn.image = UIImage(named: "liked")
        }else{
            //            likesRef.child(currentUserID!).removeValue()
            self.likeBtn.image = UIImage(named: "like")
            NotificationService.ignoreActivity(userID: currentUserID!, post: post!)
            
        }
        postRef = Database.database().reference().child("posts").child((post?.postID)!)
        incrementLikes(forRef: postRef)
        
        
        
    }
    
    //Edit by Tang Qian
    //    func sendLikeNotificationToDB(currentUserID: String,postID: String){
    //        let notificationRef = Database.database().reference().child("notifications")
    //        let notificationID = notificationRef.childByAutoId().key
    //        let newNotificationRef = notificationRef.child(notificationID!)
    //        newNotificationRef.setValue(["from": currentUserID,"type":"like","objectId":postID,"timestamp": Config.getCurrentTimeStamp()])
    //        print("send a like activity to notification")
    //
    //        sendLikeToFeedsDB( userID: currentUserID,likeNotificationID: notificationID!)
    //
    //    }
    
    //Edit by Tang Qian
    //    func sendLikeToFeedsDB(userID: String,likeNotificationID: String){
    //        Database.database().reference().child("feeds").child(userID).setValue([likeNotificationID: true])
    //
    //        Database.database().reference().child("followers").child(userID).observe(.childAdded) { (snapshot) in
    //            let followerID = snapshot.key
    //            Database.database().reference().child("feeds").child(followerID).setValue([likeNotificationID: true])
    //        }
    //
    //        print("send a like feed  to feeds")
    //    }
    
    
    @objc func commentImageViewClicked(){
        if let postID = post?.postID {
            homeTableView?.performSegue(withIdentifier: "writeCommentSegue", sender: postID)
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
}

