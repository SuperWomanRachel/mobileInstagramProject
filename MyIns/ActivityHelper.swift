//
//  ActivityHelper.swift
//  MyIns
//
//  Created by tq on 2018/10/19.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import Foundation
import Alamofire

class ActivityHelper{
    
    
    static func updateView(notification: Notification,timeLabel: UILabel,descriptionLabel: UILabel,photo: UIImageView){
        let postId = notification.objectId
        switch notification.type!{
        case "like":
            descriptionLabel.text = " liked "
            showPostPhoto(withId: postId!, photo: photo)
        case "followed":
            descriptionLabel.text = " started following "
            showPostPhoto(withId: postId!, photo: photo)
        default:
            print("defualt case")
        }
        let timestamp = notification.timestamp
        let showTime = getShowTime(timestamp: timestamp!)
        timeLabel.text = showTime
        
    }
    
    static func showPostPhoto(withId postId: String ,photo: UIImageView){
        NotificationService.observePost(withId: postId, completion: {
            post in
            if post.photoURL == nil {
                print("photo is nil")
                photo.image = UIImage(named: "profile_signUp")
            }else{
                let photoImgurl = post.photoURL
                Alamofire.request(photoImgurl!).responseImage { (response) in
                    if let image = response.result.value {
                        photo.image = image
                    }
                }
            }
            
        })
    }
    
    static func getShowTime(timestamp: Int)-> String{
        var showTime = "3"
        let timeInterval: TimeInterval = TimeInterval(timestamp)
        let timestampDate = NSDate(timeIntervalSince1970: timeInterval)
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour , .day , .weekOfMonth])
        let diff = Calendar.current.dateComponents(components,from:timestampDate as Date, to: now)
    
        if (diff.second! <= 0) {
            showTime = "Now"
        }
        if (diff.second! > 0 && diff.minute! == 0) {
            showTime = "\( diff.second!) s"
        }
        if (diff.minute! > 0 && diff.day! == 0){
            showTime = "\(diff.minute!) m"
        }
        if (diff.day!>0 && diff.weekOfMonth! == 0){
            showTime = "\( diff.day!) d"
        }
        if (diff.weekOfMonth!>0){
            showTime = "\( diff.weekOfMonth!) w"
        }
        
        return showTime
        
    }
    
    static func setupUser(user: User,usernameLabel: UILabel,profileImage:UIImageView){
        usernameLabel.text = user.username
        if user.imageUserURL == nil {
            print("profile image url is nil")
            profileImage.image = UIImage(named: "profile_signUp")
        }else{
            let userImgurl = user.imageUserURL
            Alamofire.request(userImgurl!).responseImage { (response) in
                if let image = response.result.value {
                    profileImage.image = image
                }
            }
        }

        
    }
    
    
}
