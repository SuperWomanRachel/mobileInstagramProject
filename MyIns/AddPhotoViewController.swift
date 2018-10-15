//
//  AddPhotoViewController.swift
//  MyIns
//
//  Created by CHING MAN LEE on 17/9/2018.
//  Copyright © 2018年 CHING MAN LEE. All rights reserved.
//

import UIKit
import CoreImage
import Alamofire
import AlamofireImage
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import GeoFire

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, PopoverViewControllerDelegate, CLLocationManagerDelegate {
    
    //ADDED by @jingyuanb
    var locationManager = CLLocationManager() //location
//    var myLocation: CLLocation?
    var myLocationCoor: CLLocationCoordinate2D?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    //ADDED by @jingyuanb
    @IBOutlet weak var sharePostBtn: UIButton!
    @IBOutlet weak var captionTextField: UITextView!
    
    let imagePicker = UIImagePickerController()
    var originalImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        showImagePickerForSourceType(.photoLibrary)
        //ADDED by @jingyuanb
        startUseLocation()
        
    }
    
    //ADDED by @jingyuanb
    fileprivate func startUseLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("allowed to use location")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ADD THIS by @jingyuanb
        handleSharePostValid()
    }
    
    //ADD THIS by @jingyuanb
    @IBAction func sharePostBtnClicked(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Please wait...")
        if let photoData = UIImagePNGRepresentation(imageView.image!) {
            let photoID = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("postPhotos").child(photoID)
            storageRef.putData(photoData, metadata: nil) { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    self.sendDataToDB(photoURL: (url?.absoluteString)!)
                })
            }
            
        }
        handleSharePostValid()
    }
    //ADDED by @jingyuanb
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //ADD THIS by @jingyuanb
    func handleSharePostValid(){
        if imageView != nil && imageView.image != nil {
            sharePostBtn.isEnabled = true
            sharePostBtn.setTitleColor(UIColor.blue, for: UIControlState.normal)
//            self.sharePostBtn.backgroundColor=UIColor(red: 41/255, green: 109/255, blue: 255/255, alpha: 1)
        }else {
            sharePostBtn.isEnabled = false
            sharePostBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
//            self.sharePostBtn.backgroundColor=UIColor(red: 170/255, green: 199/255, blue: 255/255, alpha: 1)
        }
    }
    //ADD THIS by @jingyuanb
    func sendDataToDB(photoURL: String){
        let caption = self.captionTextField.text!
        let dbRef = Database.database().reference().child("posts")
        let postID = dbRef.childByAutoId().key
        guard let currentUser = Auth.auth().currentUser else { return  }
        let currentUserID = currentUser.uid
        let postRef = dbRef.child(postID!)
        let now = Config.getCurrentTimeStamp()
        let latitude = Double(String(format: "%.1f", myLocationCoor!.latitude))
        let longitude = Double(String(format: "%.1f", myLocationCoor!.longitude))
        postRef.setValue(["uid": currentUserID, "photoURL": photoURL, "caption": caption, "timestamp": now, "longitude": longitude!, "latitude": latitude!]) { (error, dbRef) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }

            self.sendToMyPostsDB(postID: postID!, userID: currentUserID)

            ProgressHUD.showSuccess("Success")
            self.imageView.image = nil
            self.captionTextField.text = ""
            self.handleSharePostValid()
            self.tabBarController?.selectedIndex = 0
            }
        
    }
    //send post to db: myPosts
    func sendToMyPostsDB(postID: String, userID: String){
        _ = Database.database().reference().child("myPosts").child(userID).child(postID).setValue(true) { (error, mypostRef) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
        }
    }
    
    //ADDED by @jingyuanb
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    //ADDED by @jingyuanb
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
//            print(location.coordinate) //print out the coordinates of your location
//            self.myLocation = location
            self.myLocationCoor = location.coordinate
            
        }
    }
    
    
    func filtering(filterOption: String){
        
        let inputImage = originalImage
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name: filterOption) {
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    self.imageView.image = processedImage
                }
            }
        }
    }
    
    func brightness(value: Float){
        let inputImage = imageView.image!
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name: "CIColorControls") {
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: "inputImage")
            currentFilter.setValue(NSNumber(value: value), forKey: "inputBrightness")
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    self.imageView.image = processedImage
                }
            }
        }
    }
    
    func contrast(value: Float){
        let inputImage = originalImage
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name: "CIColorControls") {
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: "inputImage")
            currentFilter.setValue(NSNumber(value: value), forKey: "inputContrast")
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    self.imageView.image = processedImage
                }
            }
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //self.imageView.image = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterOptions" {
            let popoverViewController = segue.destination as! PopoverViewController
            popoverViewController.delegate = self
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.preferredContentSize = CGSize(width: 200, height: 200)
            popoverViewController.popoverPresentationController!.delegate = self
            //self.present(popoverViewController, animated: true)
            
        }else if segue.identifier == "brightness" || segue.identifier == "contrast"{
            let popoverViewController = segue.destination as! PopoverViewController
            popoverViewController.delegate = self
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.preferredContentSize = CGSize(width: 300, height: 43.5)
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "filterOptions" || identifier == "brightness" || identifier == "contrast" {
            if imageView.image == nil{
                print("Please choose a photo first.")
                showToast(controller: self, message: "Please choose a photo first.", seconds: 0.5)
                return false
            }
        }
        return true
    }
    
    func messageData(type: String, data: AnyObject) {
        print(data)
        if type == "filter"{
            filtering(filterOption: data as! String)
        }else if type == "brightness"{
            brightness(value: data as! Float)
        }else if type == "contrast"{
            contrast(value: data as! Float)
        }
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+seconds, execute: {alert.dismiss(animated: true, completion: nil)})
    }
    
    @IBAction func clickLibraryButton(_ sender: UIBarButtonItem) {
        showImagePickerForSourceType(.photoLibrary)
    }
    @IBAction func clickClearButton(_ sender: UIBarButtonItem) {
        
        self.imageView.image = nil

        //ADD THIS by @jingyuanb
        self.captionTextField.text = ""
        self.handleSharePostValid()

        
        //ADD THIS by @jingyuanb
        self.handleSharePostValid()
    }
    
    @IBAction func clickCameraButton(_ sender: UIBarButtonItem) {
        showImagePickerForSourceType(.camera)
    }
    
    func showImagePickerForSourceType(_ sourceType: UIImagePickerControllerSourceType) {
        DispatchQueue.main.async(execute: {
            self.imagePicker.allowsEditing = true
            self.imagePicker.modalPresentationStyle = .currentContext
            self.imagePicker.sourceType = sourceType
            if sourceType == .camera{
                self.imagePicker.cameraFlashMode = .on
            }
            
            self.imagePicker.delegate = self
            
            self.show(self.imagePicker, sender: (Any?).self)
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIImagePickerControllerDelegate_Protocol/index.html#//apple_ref/doc/constant_group/Editing_Information_Keys
        
        picker.dismiss(animated: true) {
            
            print("media type: \(String(describing: info[UIImagePickerControllerMediaType]))")
            
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                self.originalImage = image
                self.imageView.image = image
                self.imageView.contentMode = .scaleAspectFit
                
               //ADD THIS by @jingyuanb
                self.handleSharePostValid()
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

protocol PopoverViewControllerDelegate {
    func messageData(type: String, data: AnyObject)
}

class PopoverViewController: UITableViewController {
    
    var delegate: PopoverViewControllerDelegate?
    
    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBOutlet weak var contrastSlider: UISlider!
    
    @IBAction func brightnessOK(_ sender: UIButton) {
        print("Brightness Slider here")
        print(brightnessSlider.value)
        
        self.presentingViewController!.dismiss(animated: true, completion: nil)
        self.delegate?.messageData(type: "brightness", data: brightnessSlider.value as AnyObject)
    }
    
    @IBAction func contrastOK(_ sender: UIButton) {
        print("contrast Slider here")
        print(contrastSlider.value)
        
        self.presentingViewController!.dismiss(animated: true, completion: nil)
        self.delegate?.messageData(type: "contrast", data: contrastSlider.value as AnyObject)
    }
    
    
    @IBAction func filterButton(_ sender: UIButton) {
        print("Filter here")
        
        if sender.currentTitle != ""{
            self.presentingViewController!.dismiss(animated: true, completion: nil)
            self.delegate?.messageData(type: "filter", data: sender.currentTitle! as AnyObject)
        }
    }

    
}




