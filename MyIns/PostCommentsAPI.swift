//
//  PostCommentsAPI.swift
//  MyIns
//
//  Created by Jingyuan Bi on 19/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class PostCommentsAPI{
    
    var PostComments_REF = Database.database().reference().child("postComments")
    
    func fetchPostComments(withPostID postID: String, Completion: @escaping(String) -> Void){
        self.PostComments_REF.child(postID).observe(.childAdded) { (pcsnapshot) in
            Completion(pcsnapshot.key)
//            API.comment.fetchComment(withCommentID: pcsnapshot.key, Competion: { (comment) in
//                API.user.fetchUser(uid: comment.uid!, completion: { (user) in
//                })
//            })
        }
    }
    
    func postNewComment(postID: String, commentText: String){
        let commentsRef = API.comment.Comment_REF;
        let commentID = commentsRef.childByAutoId().key
        let newCommentRef = commentsRef.child(commentID!)
        guard let currentUser = Auth.auth().currentUser else { return  }
        let currentUserID = currentUser.uid
        let now = Config.getCurrentTimeStamp()
        newCommentRef.setValue(["uid": currentUserID,"commentText": commentText, "timestamp":now ]) { (error, newCommentRef) in
            if error != nil {
                ProgressHUD.showError(error as! String)
                return
            }
            let postCommentsRef = self.PostComments_REF.child(postID).child(commentID!)
            postCommentsRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error as! String)
                    return
                }
            })
        }
    }
}
