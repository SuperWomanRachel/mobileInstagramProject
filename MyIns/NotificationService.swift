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
        
        sendActivityToFeedsDB( userID: currentUserID,notificationID: notificationID!,postID: postID!)
        sendYouActivityToFeedsDB(post: post,notificationID: notificationID!)
    }
    
    static func sendActivityToFeedsDB(userID: String,notificationID: String,postID: String){
        print("newsendActivityToFeedsDB")
        Config.REF_ACTIVITYFEEDS.child(userID).child(notificationID).setValue(true)
        
        Config.REF_DB.child("followers").child(userID).observe(.childAdded) { (snapshot) in
            let followerID = snapshot.key
            Config.REF_DB.child("activityFeeds").child(followerID).child(notificationID).setValue( true)
        }
        
        
        Config.REF_POSTS.child(postID).child("likes").child(userID).setValue(notificationID)
        print("change the value of the user in likes to notificationID ,uID is "+"\(userID)"+",****noteID is\(notificationID)")
        
    }
    
    
    static func sendYouActivityToFeedsDB(post:Post,notificationID: String){
        let receiverID = post.uid
        Config.REF_YOUACTIVITYFEEDS.child(receiverID!).child(notificationID).setValue(true)

    }
    
    static func removeActivity(userID: String,post: Post,noteID: String){
        print("ignoreActivity")
        print("noteID : " + "\(noteID)")
        removeActivityInFeedsDB(userID: userID, notificationID: noteID)
        removeYouActivityInFeedsDB(post: post, notificationID: noteID)

    }
    
    static func removeActivityInFeedsDB(userID: String,notificationID: String){
        Config.REF_ACTIVITYFEEDS.child(userID).child(notificationID).removeValue()
        Config.REF_DB.child("followers").child(userID).observe(.childAdded) { (snapshot) in
            let followerID = snapshot.key
            Config.REF_DB.child("activityFeeds").child(followerID).child(notificationID).removeValue()
        }
    }
    
    static func removeYouActivityInFeedsDB(post:Post,notificationID: String){
        let receiverID = post.uid
        Config.REF_YOUACTIVITYFEEDS.child(receiverID!).child(notificationID).removeValue()

    }
    
    
    
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
