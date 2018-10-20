//
//  AlertProtocol.swift
//  MyIns
//
//  Created by CHING MAN LEE on 17/10/2018.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

protocol AlertProtocol {}

extension AlertProtocol where Self: UIViewController {
    
    func createAlertWithMsgAndTitle(_ title: String, msg: String) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Accept", style: .cancel, handler: { (alert) -> Void in
            alertController.removeFromParentViewController()
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
