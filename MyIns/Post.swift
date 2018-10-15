//
//  Post.swift
//  MyIns
//
//  Created by Jingyuan Bi on 30/9/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation

import FirebaseAuth

//import CoreLocation


class Post {
    var caption: String? = ""
    var photoURL: String? = ""
    var uid: String? = ""
    var postID : String? = ""
    var timestamp: Int?
    var likes: Dictionary<String, Any>?
    var latitude: Double?
    var longitude: Double?

    var isLike: Bool?


    
    static func transformPost(dict:[String: Any], postID: String) -> Post{
        let post = Post()
        post.caption = dict["caption"] as? String
        post.photoURL = dict["photoURL"] as? String
        post.uid = dict["uid"] as? String
        post.timestamp = dict["timestamp"] as? Int
        post.postID = postID
        post.likes = dict["likes"] as? Dictionary<String, Any>

        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                if post.likes?[currentUserId] != nil {
                    post.isLike = true
                }else{
                    post.isLike = false
                }
            }else {
                post.isLike = false
            }
        }

        post.latitude = dict["latitude"] as? Double
        post.longitude = dict["longitude"] as? Double
        return post
    }
}
