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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame.origin.y += 100
        pagingMenuController.view.frame.size.height -= 64
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

