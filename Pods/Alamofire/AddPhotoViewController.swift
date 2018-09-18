//
//  AddPhotoViewController.swift
//  MyInstagram
//
//  Created by CHING MAN LEE on 17/9/2018.
//  Copyright © 2018年 CHING MAN LEE. All rights reserved.
//

import UIKit
import CoreImage

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, PopoverViewControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    var originalImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        showImagePickerForSourceType(.photoLibrary)
        
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

