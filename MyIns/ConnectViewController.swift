//
//  ConnectViewController.swift
//  MyIns
//
//  Created by CHING MAN LEE on 17/10/2018.
//  Copyright © 2018年 Jingyuan Bi. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ConnectViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, AlertProtocol{
    
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var chatScrollView: UIScrollView!
    
    @IBOutlet weak var chatStackView: UIStackView!
    //@IBOutlet weak var chatView: UITextView!
    @IBOutlet weak var messageField: UITextField!
    
    //@IBOutlet weak var swipeButton: UIBarButtonItem!
    
    let serviceType = "MyIns"
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var session: MCSession!
    var peerID: MCPeerID!
    let imagePicker = UIImagePickerController()
    var imageToSwipe = UIImage()
    var firstSwipeDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add tap gesture to chat view to dismiss keyboard
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGuesture.cancelsTouchesInView = false
        chatStackView.addGestureRecognizer(tapGuesture)
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // the browser
        self.browser = MCBrowserViewController(serviceType: serviceType, session: self.session)
        self.browser.delegate = self
        
        // the advertiser
        self.assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: self.session)
        // start advertising
        self.assistant.start()
        
        
        self.present(self.browser, animated: true, completion: nil)
        self.chatStackView.axis = .vertical
        self.chatStackView.distribution = .equalSpacing
        self.chatStackView.alignment = .fill
        self.chatStackView.spacing = 10
        self.chatStackView.translatesAutoresizingMaskIntoConstraints = false
        self.chatStackView.leadingAnchor.constraint(equalTo: self.chatScrollView.leadingAnchor).isActive = true
        self.chatStackView.trailingAnchor.constraint(equalTo: self.chatScrollView.trailingAnchor).isActive = true
        self.chatStackView.topAnchor.constraint(equalTo: self.chatScrollView.topAnchor).isActive = true
        self.chatStackView.bottomAnchor.constraint(equalTo: self.chatScrollView.bottomAnchor).isActive = true
        self.chatStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        print("connect here")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    /*
     @IBAction func swipePhoto(_ sender: UIBarButtonItem) {
     
     //self.imageToSwipe = UIImage(named: "AppIcon")!
     print("self.imageToSwipe", self.imageToSwipe)
     self.sendImage(img: self.imageToSwipe)
     
     }*/
    
    
    func sendImage(img: UIImage) {
        if self.session.connectedPeers.count > 0 {
            print("22222222")
            if let imageData = UIImagePNGRepresentation(img) {
                do {
                    try self.session.send(imageData, toPeers: self.session.connectedPeers, with: .reliable)
                    print("sendImage")
                    self.updateChatWithImage("image", fromPeer: self.peerID, image: self.imageToSwipe)
                    
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    @IBAction func showBrowser(_ sender: UIButton) {
        // show the browser view controller
        self.present(self.browser, animated: true, completion: nil)
        
    }
    
    @IBAction func sendChat(_ sender: UIButton) {
        
        let msg = self.messageField.text!.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        do {
            try self.session.send(msg!, toPeers: self.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
            
            self.updateChat(self.messageField.text!, fromPeer: self.peerID)
            
            self.messageField.text = ""
            
        } catch let error as NSError {
            createAlertWithMsgAndTitle("Error", msg: error.localizedDescription)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // browser delegate's methods
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // "Done" was tapped
        if firstSwipeDone == false{
            self.sendImage(img: self.imageToSwipe)
            firstSwipeDone = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // "Cancel" was tapped
        self.dismiss(animated: true, completion: nil)
    }
    
    // session delegate's methods
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async { [unowned self] in
                self.updateChatWithImage("", fromPeer: peerID, image: image)
                
            }
        }else{
            // when receiving a data
            DispatchQueue.main.async(execute: {
                let msg = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                
                self.updateChat(msg, fromPeer: peerID)
            })
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    // MARK: Keyboard notification
    
    @objc func keyboardWillShow(_ sender: Foundation.Notification) {
        if let keyboardFrame = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomViewConstraint.constant = keyboardHeight
            }, completion: { (completed) in
                if completed {
                    //self.chatView.scrollRangeToVisible(NSMakeRange(self.chatView.text.characters.count-1, 0))
                }
                
            })
            
        }
    }
    
    @objc func keyboardWillHide(_ sender: Foundation.Notification) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomViewConstraint.constant = 0
        })
        
    }
    
    @objc func dismissKeyboard(_ sender:UITapGestureRecognizer) {
        messageField.resignFirstResponder()
    }
    
    func updateChat(_ text: String, fromPeer peerID: MCPeerID) {
        var name: String
        
        switch peerID {
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        print("hi!!!")
        let message = "\(name): \(text)\n"
        
        let newLabel = UILabel()
        newLabel.text = message
        
        self.chatStackView.addArrangedSubview(newLabel)
    }
    
    func updateChatWithImage(_ text: String, fromPeer peerID: MCPeerID, image: UIImage) {
        var name: String
        
        switch peerID {
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        
        let message = "\(name): \n"
        let newLabel = UILabel()
        newLabel.text = message
        
        self.chatStackView.addArrangedSubview(newLabel)
        
        
        let newChatContent = UIImageView()
        
        newChatContent.contentMode = .scaleAspectFit
        
        if image.size.width > self.view.frame.size.width{
            let newSize = CGSize(width: self.view.frame.size.width, height: image.size.height*(self.view.frame.size.width/image.size.width))
            newChatContent.image = resizeImage(image: image, targetSize: newSize)
        }else{
            newChatContent.image = image
        }
        
        
        
        print("size", newChatContent.frame.size)
        self.chatStackView.addArrangedSubview(newChatContent)
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}


