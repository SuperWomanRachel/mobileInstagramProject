//
//  SendDataToDB.swift
//  MyIns
//
//  Created by Jingyuan Bi on 21/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation
import Firebase

class SendDataToDB{
    
    var PostPhotos_storage_REF = Storage.storage().reference().child("postPhotos")
    var Feeds_REF = Database.database().reference().child("feeds")
    
    
    func sendToMyPostsDB(postID: String, userID: String){
        _ = Database.database().reference().child("myPosts").child(userID).child(postID).setValue(true) { (error, mypostRef) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
        }
    }
    
    func sendToFeedsDB(postID: String, userID: String){
        Database.database().reference().child("feeds").child(userID).child(postID).setValue(true)
        Database.database().reference().child("followers").child(userID).observe(.childAdded) { (snapshot) in
            let followerID = snapshot.key
            Database.database().reference().child("feeds").child(followerID).child(postID).setValue(true)
        }
    }
    
    func fetchPostFromFeeds(withUid currentUserID:String,Completion:@escaping(String) -> Void){
        Feeds_REF.child(currentUserID).observe(.childAdded) { (snapshot) in
            Completion(snapshot.key)
        }
    }
    
}
