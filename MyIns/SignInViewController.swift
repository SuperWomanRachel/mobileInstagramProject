//
//  SignInViewController.swift
//  MyIns
//
//  Created by tq on 2018/9/28.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInBtn.isEnabled = false
        handleTextField()
    }
    
    func handleTextField(){
        
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(){
        guard let emial = emailTextField.text, !emial.isEmpty ,let password = passwordTextField.text,!password.isEmpty
            else {
                signInBtn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signInBtn.isEnabled = false
                return
        }
        signInBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInBtn.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "signInToTabbar", sender: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    @IBAction func signInBtn_Touched(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting ...", interaction: false)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("Success!!")
            self.performSegue(withIdentifier: "signInToTabbar", sender: nil)
            
        }, onError: { error in
            ProgressHUD.showError(error!)
            print("In sing in btn touch")
            print(error!)
        })
        
    }
    

}
