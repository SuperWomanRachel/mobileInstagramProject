//
//  User.swift
//  MyIns
//
//  Created by Jingyuan Bi on 30/9/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation

class User {
    var uid: String? = ""
    var username: String? = ""
    var imageUserURL: String? = ""
    var email: String? = ""
    
    static func transformUser(dict: [String:Any], uid: String) -> User{
        let user = User()
        user.uid = uid
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.imageUserURL = dict["imageUserURL"] as? String
        return user
    }
    
   
}
