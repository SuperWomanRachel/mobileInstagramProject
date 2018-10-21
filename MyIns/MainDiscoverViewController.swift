//
//  MainDiscoverViewController.swift
//  MyIns
//
//  Created by WEN REN on 2018/10/20.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import Foundation
import UIKit
import PagingMenuController
import FirebaseAuth

class MainDiscoverViewController: UIViewController {
    
    private struct PagingMenuOptions: PagingMenuControllerCustomizable{
        private let hotUserViewController = UIStoryboard(name: "discover", bundle: nil).instantiateViewController(withIdentifier: "HotUser") as! HotUserViewController
        
        
        
        fileprivate var componentType: ComponentType{
            return .all(menuOptions: MenuOptions(),pagingControllers: pagingControllers)
        }
        
        fileprivate var pagingControllers: [UIViewController]{
            return [hotUserViewController]
        }
        
        fileprivate struct MenuOptions: MenuViewCustomizable{
            var displayMode: MenuDisplayMode{
                return .segmentedControl
            }
            
            var itemsOptions: [MenuItemViewCustomizable]{
                return [MenuItem1()]
            }
        }
        
        fileprivate struct MenuItem1: MenuItemViewCustomizable{
            var displayMode: MenuItemDisplayMode{
                return .text(title: MenuItemText(text: "Hot"))
                
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
