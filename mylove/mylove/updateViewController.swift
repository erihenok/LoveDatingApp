//
//  updateViewController.swift
//  mylove
//
//  Created by Henok Welday on 5/1/20.
//  Copyright © 2020 Henok Welday. All rights reserved.
//

import UIKit
import Parse

class updateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    // the three outlates that i need is gone here
    // profile, geneder and intrested outlets
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userGenderSwitch: UISwitch!
    
    @IBOutlet weak var intrestedGenderSwitch: UISwitch!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        errorLabel.isHidden = true
        
        
        if let isFemale = PFUser.current()? ["isFemale"] as? Bool {
            
            userGenderSwitch.setOn(isFemale, animated: false)
            
        }
        
        if let isIntrestedInWomen = PFUser.current()? ["isIntrestedInWomen"] as? Bool {
            
            intrestedGenderSwitch.setOn(isIntrestedInWomen, animated: false)
            
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFileObject {

            photo.getDataInBackground(block: { (data,error) in
                
                if let imageData = data {
                    if let image = UIImage(data: imageData){
                        self.profileImageView.image = image
                    }
                }
                
                
            })
        }
    }
    
    // the two actions upoadte image and update buttons
    
    @IBAction func updateImageTapped(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profileImageView.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // her am gone upload the infromation such as upload image, geneder and intrested to the parse service
    
    @IBAction func updateTapped(_ sender: Any) {
        
        PFUser.current()? ["isFemale"] = userGenderSwitch.isOn
        PFUser.current()? ["isIntrestedInWomen"] = intrestedGenderSwitch.isOn
        
        if let image = profileImageView.image  {
            
            // here the UIImageJPEGRepresentation(image) is not work it replaced by image.jpegData(compressionQuality: 0.75)
            
            if let imageData = image.jpegData(compressionQuality: 0.75) {
                
                PFUser.current()? ["photo"] = PFFileObject(name: "profile.png" , data: imageData)
                
                PFUser.current()? .saveInBackground(block: { (success, error) in
                    
                    if error != nil {
                                    
                                     var errorMessage = "up date-filled please try again"
                                     
                                     if let newError = error as NSError? {
                                         
                                         if let detailError = newError.userInfo["error"]as? String{
                                             
                                             errorMessage = detailError
                                         }
                                     }
                                     self.errorLabel.isHidden = false
                                     self.errorLabel.text = errorMessage
                                 } else {
                        
                                 print("update successful")
                                 }
                    })
                }
            
        }
    }
    
}
