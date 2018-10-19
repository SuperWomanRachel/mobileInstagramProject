//
//  ActivityViewController.swift
//  MyIns
//
//  Created by tq on 2018/10/15.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit
import PagingMenuController
import FirebaseAuth

class ActivityViewController: UIViewController {
    
    private struct PagingMenuOptions: PagingMenuControllerCustomizable{
        
        
        private let followingActivityViewController = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "FollowingActivityViewController") as! FollowingActivityViewController
        
        private let youActivityViewController = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "YouActivityViewController") as! YouActivityViewController
        
        
        fileprivate var componentType: ComponentType{
            return .all(menuOptions: MenuOptions(),pagingControllers: pagingControllers)
        }
        
        fileprivate var pagingControllers: [UIViewController]{
            return [followingActivityViewController,youActivityViewController]
        }
        
        fileprivate struct MenuOptions: MenuViewCustomizable{
            var displayMode: MenuDisplayMode{
                return .segmentedControl
            }
            
            var itemsOptions: [MenuItemViewCustomizable]{
                return [MenuItem1(),MenuItem2()]
            }
        }
        
        
        
        fileprivate struct MenuItem1: MenuItemViewCustomizable{
            var displayMode: MenuItemDisplayMode{
                return .text(title: MenuItemText(text: "FOLLOWING"))
                
            }
        }
        
        fileprivate struct MenuItem2: MenuItemViewCustomizable{
            var displayMode: MenuItemDisplayMode{
                
                return .text(title: MenuItemText(text: "YOU"))
            }
        }
        
    }
    
    var notifications = [Notification]()
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame.origin.y += 100
        pagingMenuController.view.frame.size.height -= 64
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        
        
    }
    
//    func loadActivity(){
//        
//        guard let currentUser = Auth.auth().currentUser?.uid else {
//            return
//        }
//        NotificationService.observeNotification(withId: currentUser) { (notification) in
//            guard let uid = notification.from else{
//                return
//            }
//            self.fetchUser(uid: uid, completion: {
//                self.notifications.insert(notification, at: 0)
//            })
//        }
//        
//    }
//    
//    func fetchUser(uid: String, completion: @escaping ()->Void){
//        NotificationService.observeUser(withId: uid, completion: {
//            user in
//            self.users.insert(user, at: 0)
//            completion()
//        })
//    
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

