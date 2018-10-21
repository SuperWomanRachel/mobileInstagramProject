//
//  NotificationService.swift
//  MyIns
//
//  Created by tq on 2018/10/17.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NotificationService{
    
    static func uploadActivity(currentUserID: String,post: Post,type: String){
        let notificationID = Config.REF_NOTIFICATIONS.childByAutoId().key
        let newNotificationRef = Config.REF_NOTIFICATIONS.child(notificationID!)
        let postID = post.postID
        newNotificationRef.setValue(["from": currentUserID,"type":type,"objectId":postID!,"timestamp": Config.getCurrentTimeStamp()])
        print("send a activity to notification")
        
        sendActivityToFeedsDB( userID: currentUserID,notificationID: notificationID!)
        sendYouActivityToFeedsDB(post: post,notificationID: notificationID!)
    }
    
    static func sendActivityToFeedsDB(userID: String,notificationID: String){
        Config.REF_ACTIVITYFEEDS.child(userID).child(notificationID).setValue(true)
        
        Config.REF_DB.child("followers").child(userID).observe(.childAdded) { (snapshot) in
            let followerID = snapshot.key
            Config.REF_DB.child("activityFeeds").child(followerID).child(notificationID).setValue( true)
        }
    
    }
    
    static func sendYouActivityToFeedsDB(post:Post,notificationID: String){
        let receiverID = post.uid
        Config.REF_YOUACTIVITYFEEDS.child(receiverID!).child(notificationID).setValue(true)
        print("check if the receiver's feed successfully updated&&&&&&&&&&&&&&&&&")
        print(receiverID!)
        print(notificationID)
    }
    //TODO: the problem is : cannot get the notification Id when a user unlike/unfollow something
    static func ignoreActivity(){
        
    }
    
    static func ignoreActivityInFeedsDB(userID: String,notificationID: String){
        Config.REF_ACTIVITYFEEDS.child(userID).child(notificationID).setValue(false)
        Config.REF_DB.child("followers").child(userID).observe(.childAdded) { (snapshot) in
            let followerID = snapshot.key
            Config.REF_DB.child("activityFeeds").child(followerID).child(notificationID).setValue(false)
        }
    }
    
    static func ignoreYouActivityInFeedsDB(post:Post,notificationID: String){
        let receiverID = post.uid
        Config.REF_YOUACTIVITYFEEDS.child(receiverID!).child(notificationID).setValue(false)
        print("check if the receiver's feed set to false")
        print(receiverID)
        print(notificationID)
    }
    
    
    //TODO: if cancel the like or follow(set the noteid value as false), those method need to modified.In the feed, for a user , need to check the value of noteid, only true value needed to be observed
    static func observeNotification(withId id: String, completion:@escaping (Notification)->Void){
        Config.REF_ACTIVITYFEEDS.child(id).observe(.childAdded,with:{snapshot in
            Config.REF_NOTIFICATIONS.child(snapshot.key).observeSingleEvent(of: .value, with: { (noteSnapshot) in
                if let dict = noteSnapshot.value as? [String:Any] {
                    let newNotification = Notification.transformNotification(dict: dict, notificationId: noteSnapshot.key)
                    completion(newNotification)
                }

            })
            
        })
    }
    
    static func observeMyNotification(withId id: String, completion:@escaping (Notification)->Void){
        Config.REF_YOUACTIVITYFEEDS.child(id).observe(.childAdded,with:{snapshot in
            Config.REF_NOTIFICATIONS.child(snapshot.key).observeSingleEvent(of: .value, with: { (noteSnapshot) in
                if let dict = noteSnapshot.value as? [String:Any] {
                    let newNotification = Notification.transformNotification(dict: dict, notificationId: noteSnapshot.key)
                    completion(newNotification)
                }
                
            })
            
        })
    }
    
    
    
    static func observeUser(withId id: String, completion:@escaping (User)->Void){
        Config.REF_USER.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                let newUser = User.transformUser(dict: dict, uid: snapshot.key)
                completion(newUser)
            }
        })
        
    }
    
    static func observePost(withId id: String, completion:@escaping (Post)->Void){
        Config.REF_POSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                let newPost = Post.transformPost(dict: dict, postID: snapshot.key)
                completion(newPost)
            }
        })
        
    }
    
    
}
