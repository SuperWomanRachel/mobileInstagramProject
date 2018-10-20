//
//  File.swift
//  MyIns
//
//  Created by tq on 2018/10/16.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import Foundation
class Notification{
    var from: String? = ""
    var objectId: String? = ""
    var type: String? = ""
    var id: String? =  ""
    var timestamp: Int?
    
    
    static func transformNotification(dict:[String: Any], notificationId: String) -> Notification{
        let notification = Notification()
        notification.id = notificationId
        notification.objectId = dict["objectId"] as? String
        notification.type = dict["type"] as? String
        notification.timestamp = dict["timestamp"] as? Int
        notification.from = dict["from"] as! String
    
        return notification
    }
}
