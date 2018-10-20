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
    
    static var REF_DB = Database.database().reference()
    static var REF_NOTIFICATIONS = REF_DB.child("notifications")
    static var REF_USER = REF_DB.child("users")
    static var REF_ACTIVITYFEEDS = REF_DB.child("activityFeeds")
    static var REF_POSTS = REF_DB.child("posts")
    static var REF_YOUACTIVITYFEEDS = REF_DB.child("youActivityFeeds")
    
    
    static func uploadActivity(currentUserID: String,post: Post,type: String){
        let notificationID = REF_NOTIFICATIONS.childByAutoId().key
        let newNotificationRef = REF_NOTIFICATIONS.child(notificationID!)
        let postID = post.postID
        newNotificationRef.setValue(["from": currentUserID,"type":type,"objectId":postID,"timestamp": Config.getCurrentTimeStamp()])
        print("send a activity to notification")
        
        sendActivityToFeedsDB( userID: currentUserID,notificationID: notificationID!)
        sendYouActivityToFeedsDB(post: post,notificationID: notificationID!)
    }
    
    static func sendActivityToFeedsDB(userID: String,notificationID: String){
        REF_ACTIVITYFEEDS.child(userID).child(notificationID).setValue(true)
        
        REF_DB.child("followers").child(userID).observe(.childAdded) { (snapshot) in
            let followerID = snapshot.key
            REF_DB.child("activityFeeds").child(followerID).child(notificationID).setValue( true)
        }
       
        
        print("send a feed  to ActivityFeeds")
    }
    
    static func sendYouActivityToFeedsDB(post:Post,notificationID: String){
        let receiverID = post.uid
        REF_YOUACTIVITYFEEDS.child(receiverID!).child(notificationID).setValue(true)
        print("check if the receiver's feed successfully updated&&&&&&&&&&&&&&&&&")
        print(receiverID)
        print(notificationID)
    }
    
    static func uploadFollowingActivity(){
        
    }

    
    static func observeNotification(withId id: String, completion:@escaping (Notification)->Void){
        REF_ACTIVITYFEEDS.child(id).observe(.childAdded,with:{snapshot in
            REF_NOTIFICATIONS.child(snapshot.key).observeSingleEvent(of: .value, with: { (noteSnapshot) in
                if let dict = noteSnapshot.value as? [String:Any] {
                    let newNotification = Notification.transformNotification(dict: dict, notificationId: noteSnapshot.key)
                    completion(newNotification)
                }

            })
            
        })
    }
    
    static func observeMyNotification(withId id: String, completion:@escaping (Notification)->Void){
        REF_YOUACTIVITYFEEDS.child(id).observe(.childAdded,with:{snapshot in
            REF_NOTIFICATIONS.child(snapshot.key).observeSingleEvent(of: .value, with: { (noteSnapshot) in
                if let dict = noteSnapshot.value as? [String:Any] {
                    let newNotification = Notification.transformNotification(dict: dict, notificationId: noteSnapshot.key)
                    completion(newNotification)
                }
                
            })
            
        })
    }
    
    
    
    static func observeUser(withId id: String, completion:@escaping (User)->Void){
        REF_USER.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                let newUser = User.transformUser(dict: dict, uid: snapshot.key)
                completion(newUser)
            }
        })
        
    }
    
    static func observePost(withId id: String, completion:@escaping (Post)->Void){
        REF_POSTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any]{
                let newPost = Post.transformPost(dict: dict, postID: snapshot.key)
                completion(newPost)
            }
        })
        
    }
    
    
}
