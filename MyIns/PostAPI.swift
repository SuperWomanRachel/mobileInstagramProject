//
//  PostAPI.swift
//  MyIns
//
//  Created by Jingyuan Bi on 19/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation
import Firebase

class PostAPI{
    
    var Post_REF = Database.database().reference().child("posts")
    
    func fetchPost(withPostID postID: String, completion: @escaping(Post) -> Void){
        API.post.Post_REF.child(postID).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let post = Post.transformPost(dict: dict, postID: postID)
                completion(post)
            }
        })
    }
}
