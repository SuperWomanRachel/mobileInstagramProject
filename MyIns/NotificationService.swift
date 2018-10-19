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
    
    static func uploadLikeActivity(currentUserID: String,postID: String){
        let notificationID = REF_NOTIFICATIONS.childByAutoId().key
        let newNotificationRef = REF_NOTIFICATIONS.child(notificationID!)
        newNotificationRef.setValue(["from": currentUserID,"type":"like","objectId":postID,"timestamp": Config.getCurrentTimeStamp()])
        print("send a like activity to notification")
        
        self.sendActivityToFeedsDB( userID: currentUserID,activityID: notificationID!)
    }
    
    static func sendActivityToFeedsDB(userID: String,activityID: String){
        REF_DB.child("activityFeeds").child(userID).setValue([activityID: true])
        
        REF_DB.child("followers").child(userID).observe(.childAdded) { (snapshot) in
            let followerID = snapshot.key
            REF_DB.child("activityFeeds").child(followerID).setValue([activityID: true])
        }
        
        print("send a feed  to ActivityFeeds")
    }
    
    
    static func uploadFollowingActivity(){
        
    }
    static func loadActivity(){
        
    }
    
    static func observeNotification(withId id: String, completion:@escaping (Notification)->Void){
        REF_ACTIVITYFEEDS.child(id).observe(.childAdded,with:{snapshot in
            REF_NOTIFICATIONS.child(snapshot.key).observeSingleEvent(of: .value, with: { (noteSnapshot) in
                if let dict = noteSnapshot.value as? [String:Any] {
                    let notification = Notification.transformNotification(dict: dict, notificationId: noteSnapshot.key)
                    
                }

            })
            
        })
    }
    
    static func observeUser(withId id: String, completion:@escaping (User)->Void){
        REF_USER.child(id).observe(.childAdded,with:{snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let newUser = User.transformUser(dict: dict, uid: snapshot.key)
                completion(newUser)
            }
            
        })
        
        
    }
    
    
}
