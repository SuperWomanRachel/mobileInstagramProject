//
//  ProfileViewController.swift
//  MyIns
//
//  Created by Jingyuan Bi on 4/10/18.
//  Copyright © 2018 Jingyuan Bi. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func logoutBtnClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        //print(Auth.auth().currentUser as Any)
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
