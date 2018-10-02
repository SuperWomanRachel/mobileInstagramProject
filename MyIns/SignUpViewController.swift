//
//  SignUpViewController.swift
//  MyIns
//
//  Created by tq on 2018/9/28.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = 43
        profileImage.clipsToBounds = true
        
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tabGesture)
        profileImage.isUserInteractionEnabled = true
        
        signUpBtn.isEnabled = false
        handleTextField()
    }
    
    @objc func handleSelectProfileImageView(){
        print("Image View Tapped!!!")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func handleTextField(){
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(){
        guard let username = usernameTextField.text, !username.isEmpty, let emial = emailTextField.text, !emial.isEmpty ,let password = passwordTextField.text,!password.isEmpty
            else {
                signUpBtn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signUpBtn.isEnabled = false
                return
        }
        signUpBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpBtn.isEnabled = true
    }
    
    
    @IBAction func backToSignInView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched began keyboard test")
        view.endEditing(true)
    }
    
    @IBAction func signUpBtn_Touched(_ sender: Any) {
        ProgressHUD.show("Waiting ...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg,0.1){
            print("button clicked")
            AuthService.signUp(username: self.usernameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!,imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Success")
                print("on success, sigh UP BTN TOuch")
                self.performSegue(withIdentifier: "signUpToTabbar", sender: nil)
                //let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
                //let signInVC = mainstoryboard.instantiateViewController(withIdentifier: "SignInViewController")
                //self.present(signInVC, animated: true, completion: nil)
                
            }) { (errorMsg) in
                print("show errorMsg")
                ProgressHUD.showError(errorMsg!)
                print("sign up error in her")
                print(errorMsg!)
            }
        }
        else{
            ProgressHUD.showError("Please choose a profile")
            print("profile can't be empty!")
        }
        
    }
    

}
extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Did pick somthing")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        print("######")
        dismiss(animated: true, completion: nil)
    }
    
    
}
