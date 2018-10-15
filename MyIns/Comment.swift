//
//  Comment.swift
//  MyIns
//
//  Created by Jingyuan Bi on 3/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import Foundation

class Comment{
    var uid: String?
    var commentText: String?
    var timestamp: Int?
    
    static func transformComment(dict : [String: Any]) -> Comment{
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        comment.timestamp = dict["timestamp"] as? Int
        return comment
    }
}
