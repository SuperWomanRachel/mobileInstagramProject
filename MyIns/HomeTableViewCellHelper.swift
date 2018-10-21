//
//  HomeTableViewCellHelper.swift
//  MyIns
//
//  Created by Jingyuan Bi on 20/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation
import Firebase

class HomeTableViewCellHelper{
    
    func observeLikeCount(withPostID postID: String, Completion: @escaping(Int) -> Void){
        API.post.Post_REF.child(postID).observe(.childChanged) { (snapshot) in
            if let likes = snapshot.value as? [String: Any]{
                let count = likes.count
                Completion(count)
            }
        }
    }
    
    func incrementLikes(forRef ref: DatabaseReference, Completion: @escaping(Post) ->Void){
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
                Completion(post)
//                self.loadLikes(post: post)
            }
        }
    }
}
