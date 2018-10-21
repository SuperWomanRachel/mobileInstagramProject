//
//  CommentAPI.swift
//  MyIns
//
//  Created by Jingyuan Bi on 19/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation
import Firebase

class CommentAPI{
    var Comment_REF = Database.database().reference().child("comments")
    
    func fetchComment(withCommentID commentID: String, Competion: @escaping(Comment) -> Void){
        Comment_REF.child(commentID).observeSingleEvent(of: .value, with: { (commentSnapshot) in
            if let dict = commentSnapshot.value as? [String: Any]{
                let comment = Comment.transformComment(dict: dict)
                Competion(comment)
            }
        })
    }
}
