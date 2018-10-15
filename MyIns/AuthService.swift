//
//  AuthService.swift
//  Ins_Clone
//
//  Created by tq on 2018/9/25.
//  Copyright © 2018年 qtang2. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService{
    
    static func signIn(email:String , password:String, onSuccess: @escaping () -> Void ,onError:@escaping (_ errorMessage:String?) -> Void){
        print("sign in")
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil{
                print(error!.localizedDescription)
                onError(error!.localizedDescription)
                return
            }
            //print(authResult?.user.email)
            //self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            onSuccess()
        }
    }
    
    
    static func signUp(username:String, email:String , password:String, imageData:Data, onSuccess: @escaping () -> Void ,onError:@escaping (_ errorMessage:String?) -> Void){
        print("Sign up")
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil{
                onError(error!.localizedDescription)
                print(error!.localizedDescription)
                return
            }
            
            let uid = authResult?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid!)
            // TODO: Maybe need to do somethingl
            print("##########################")
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    onError(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        onError(error!.localizedDescription)
                        return
                    }
                    let profile_img_url = url?.absoluteString
                    self.setUserInformation(profileImageUrl: profile_img_url!, username: username, email: email, uid: uid!,onSuccess: onSuccess)
                    
                })
            })
        }
        
    }
    
    
    static func logOut(_ sender: Any) {
        print(Auth.auth().currentUser)
        do {
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        print(Auth.auth().currentUser)
        
        print("Log out ok!!!!")
    }
    
    static func setUserInformation(profileImageUrl:String, username:String, email:String, uid:String,onSuccess: @escaping () -> Void ){
        let ref = Database.database().reference()
        let userReference = ref.child("users")
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["username": username,"email":email,"profileImageUrl":profileImageUrl])
        //self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
        print(" description \(newUserReference.description())")
        onSuccess()
    }
    
}

