//
//  LoginViewController.swift
//  mylove
//
//  Created by Henok Welday on 4/27/20.
//  Copyright © 2020 Henok Welday. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var usernameTextFiled: UITextField!
    
    @IBOutlet weak var passwordTextFiled: UITextField!
    
    @IBOutlet weak var logInSignUpButton: UIButton!
    
    @IBOutlet weak var changeLoginSiginUpButton: UIButton!
    
    var siginUPMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // this is the error message for the first time
        
        errorLabel.isHidden = true
    }
    
    @IBAction func loginSiginUpTapped(_ sender: Any) {
        
        if siginUPMode {
            
            let user = PFUser()
            
            user.username = usernameTextFiled.text
            user.password = passwordTextFiled.text
            
            user.signUpInBackground(block: {(success, error) in
                if error != nil {
                   
                    var errorMessage = "sigin up filled try again"
                    
                    if let newError = error as NSError? {
                        
                        if let detailError = newError.userInfo["error"]as? String{
                            
                            errorMessage = detailError
                        }
                    }
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                } else {
                print("sign up successful")
                }
            })
            
        } else {
            
            if let username = self.usernameTextFiled.text {
                
                if let  password = self.passwordTextFiled.text {
                    
                    PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                        
                        
                        if error != nil {
                                         
                                          var errorMessage = "Login filled try again"
                                          
                                          if let newError = error as NSError? {
                                              
                                              if let detailError = newError.userInfo["error"]as? String{
                                                  
                                                  errorMessage = detailError
                                              }
                                          }
                                          self.errorLabel.isHidden = false
                                          self.errorLabel.text = errorMessage
                                      } else {
                                      print("Login successful")
                                      }
                    }
                    
                }
            }
            
           
        }
        
    }

    @IBAction func changeLoginSignUpTapped(_ sender: Any) {
        
        if siginUPMode {
            logInSignUpButton.setTitle("Log In" , for: .normal)
            changeLoginSiginUpButton.setTitle("sign Up" , for: .normal)
            siginUPMode = false
        } else {
            
            logInSignUpButton.setTitle("sign Up" , for: .normal)
            changeLoginSiginUpButton.setTitle("Log In" , for: .normal)
             siginUPMode = true
        }
        
    }
    
}
