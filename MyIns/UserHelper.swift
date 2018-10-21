//
//  UserHelper.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class Userhelper{
    var REF_USERS = Database.database().reference().child("users")
    var CURRENT_USER = Auth.auth().currentUser
    
    var REF_CURRENT_USER: DatabaseReference?{
        guard let currentUser = Auth.auth().currentUser else{
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }
    
    func observeCurrentUser(completion: @escaping (User) -> Void){
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
        snapshot in
        if let dict = snapshot.value as? [String:Any]{
            let user = User.transformUser(dict: dict, uid: snapshot.key)
            completion(user)
        }
        })
    }
    
    func observeUser(withId uid:String, completion: @escaping (User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let user = User.transformUser(dict: dict, uid: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeAllUsers(completion: @escaping (User) -> Void){
        REF_USERS.observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let user = User.transformUser(dict: dict, uid: snapshot.key)
                if user.uid! != Helper.user.CURRENT_USER?.uid{
                    completion(user)
                }
            }
        })
    }
    
    func searchUsers(withText text:String, completion: @escaping (User) -> Void){
        REF_USERS.queryOrdered(byChild: "username_lower").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: {
            snapshot in
            snapshot.children.forEach({(s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String:Any]{
                    let user = User.transformUser(dict: dict, uid:child.key)
                    completion(user)
                }
                
            })
        })
    }
    
    func getHotUser(){
        
    }
    
    
    
}
