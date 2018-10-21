//
//  FollowHelper.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import Foundation
import FirebaseDatabase
class FollowHelper{
    var REF_FOLLOWING = Database.database().reference().child("following")
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    
    func followAction(withId id:String){
        Database.database().reference().child("myPosts").child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            //print(snapshot)
            if let dict = snapshot.value as? [String:Any]{
                for key in dict.keys{
                    Database.database().reference().child("feeds").child(Helper.user.CURRENT_USER!.uid).child(key).setValue(true)
                }
            }
        })
        REF_FOLLOWERS.child(id).child(Helper.user.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Helper.user.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unfollowAction(withId id:String){
        Database.database().reference().child("myPosts").child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String:Any]{
                print(dict)
                for key in dict.keys{
                    Database.database().reference().child("feeds").child(Helper.user.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        })
        REF_FOLLOWERS.child(id).child(Helper.user.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Helper.user.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func ifFollowing(userId: String, completed: @escaping (Bool) -> Void){
        REF_FOLLOWERS.child(userId).child(Helper.user.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull{
                completed(false)
            }
            else{
                completed(true)
            }
        })
    }
    
    func countFollowers(userid:String, completion: @escaping (Int)->Void){
        REF_FOLLOWERS.child(userid).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    func countFollowing(userid:String, completion: @escaping (Int)->Void){
        REF_FOLLOWING.child(userid).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
}
