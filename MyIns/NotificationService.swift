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
    
    static func uploadLikeActivity(currentUserID: String,postID: String){
        let notificationRef = Database.database().reference().child("notifications")
        let notificationID = notificationRef.childByAutoId().key
        let newNotificationRef = notificationRef.child(notificationID!)
        newNotificationRef.setValue(["from": currentUserID,"type":"like","objectId":postID,"timestamp": Config.getCurrentTimeStamp()])
        print("send a like activity to notification")
        
        self.sendActivityToFeedsDB( userID: currentUserID,activityID: notificationID!)
    }
    
    static func sendActivityToFeedsDB(userID: String,activityID: String){
        Database.database().reference().child("activityFeeds").child(userID).setValue([activityID: true])
        
        Database.database().reference().child("followers").child(userID).observe(.childAdded) { (snapshot) in
            let followerID = snapshot.key
            Database.database().reference().child("activityFeeds").child(followerID).setValue([activityID: true])
        }
        
        print("send a feed  to ActivityFeeds")
    }
    
    static func loadLikedActivity(){
        
    }
    
    static func uploadFollowingActivity(){
        
    }
    
    static func loadFollowingActivity(){
        
    }
    
    
    static func uploadMyLikedActivity(){
        
    }
    static func uploadMyFollowingActivity(){
        
    }
    static func loadMyLikedActivity(){
        
    }
    static func loadMyFollowingActivity(){
        
    }
    
    
    
}
