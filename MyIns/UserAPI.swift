//
//  UserAPI.swift
//  MyIns
//
//  Created by Jingyuan Bi on 19/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation
import Firebase

class UserAPI{
    
    var Users_REF = Database.database().reference().child("users")
    
    
    //load users
    func fetchUser(uid: String,completion : @escaping(User) -> Void){
        Users_REF.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let user = User.transformUser(dict: dict, uid: uid)
                //                self.users.append(user)
                //                print(user.email!)
                completion(user)
            }
        })
    }
    
}
