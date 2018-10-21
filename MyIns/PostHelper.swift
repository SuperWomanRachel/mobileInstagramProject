//
//  PostHelper.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import Foundation
import FirebaseDatabase
class PostHelper{
    var MY_POSTS = Database.database().reference().child("myPosts")
    var REF_POSTS = Database.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post) -> Void){
        REF_POSTS.observe(.childAdded, with: {
            (snapshot:DataSnapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.transformPost(dict: dict, postID: snapshot.key)
                completion(post)
            }
        })
    }
    
    func observePost(withId id:String, completion: @escaping (Post)->Void){
        REF_POSTS.child(id).observeSingleEvent(of: .value
            , with: {
                snapshot in
                if let dict = snapshot.value as? [String:Any]{
                    let post = Post.transformPost(dict: dict, postID: id)
                    completion(post)
                }
        })
    }
    
    func countLikes(withPostId id:String, completion: @escaping (Int)->Void){
        REF_POSTS.child(id).observe(.childChanged, with: {
            snapshot in
            if let count = snapshot.value as? Int{
                completion(count)
            }
        })
    }
    
    func observeTopPosts(completion: @escaping (Post) -> Void){
        REF_POSTS.queryOrdered(byChild: "likeCount").queryLimited(toLast: 20).observeSingleEvent(of: .value, with: {
            snapshot in
            let arr = snapshot.children.allObjects as! [DataSnapshot]
            for child in arr{
                if let dict = child.value as? [String:Any]{
                    let post = Post.transformPost(dict: dict, postID: snapshot.key)
                    completion(post)
                }
            }
        })
    }
    
    func loadPosts(userId:String, completion: @escaping (String) -> Void){
        MY_POSTS.child(userId).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
        
    }
    
    func countPosts(userid:String, completion: @escaping (Int) -> Void){
        MY_POSTS.child(userid).observe(.value, with: {
            snapshot in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
        
    }
}
