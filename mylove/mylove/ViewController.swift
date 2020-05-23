//
//  ViewController.swift
//  mylove
//
//  Created by Henok Welday on 4/17/20.
//  Copyright © 2020 Henok Welday. All rights reserved.
//

import UIKit
import Parse


class ViewController: UIViewController {
    
    var displayUserID = ""
    
    //    @IBOutlet weak var swipeLabel: UILabel!
    
    @IBOutlet weak var matchimageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gesture = UIPanGestureRecognizer (target: self, action: #selector(wasDragged (gestureRecocnizer: )))
        matchimageView.addGestureRecognizer(gesture)
        
        updateImage()
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let point = geoPoint {
                PFUser.current()?["location"] = point
                PFUser.current()?.saveInBackground()
            }
            
            
        }
    }
    // logout sugue
    
    //    @IBAction func logoutTapped(_ sender: Any)
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @objc func wasDragged (gestureRecocnizer: UIPanGestureRecognizer) {
        let labelPoint = gestureRecocnizer.translation(in: view)
        matchimageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width / 2 - matchimageView.center.x
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        matchimageView.transform = scaledAndRotated
        
        
        
        
        if gestureRecocnizer.state == .ended {
            
            // accepted and rejected in the parse
            
            var acceptedOrRejected = ""
            
            if matchimageView.center.x < (view.bounds.width / 2 - 100) {
                print("NOT INTRESTED")
                acceptedOrRejected = "rejected"
                
            }
            if matchimageView.center.x > (view.bounds.width / 2 + 100) {
                print("INTRESTED")
                acceptedOrRejected = "accepted"
                
                if acceptedOrRejected != "" && displayUserID != "" {
                    PFUser.current()?.addUniqueObject(displayUserID, forKey: acceptedOrRejected)
                    
                    PFUser.current()?.saveInBackground(block: { (success, error) in
                        
                        if success{
                            self.updateImage()
                        }
                    })
                }
                
            }
            rotation = CGAffineTransform(rotationAngle: 0)
            
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            
            matchimageView.transform = scaledAndRotated
            
            
            matchimageView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
        
    }
    func updateImage() {
        if let query = PFUser.query() {
            
            if let isIntrestedInWomen = PFUser.current()? ["isIntrestedInWomen"] {
                
                query.whereKey("isFemale", equalTo: isIntrestedInWomen)
            }
            
            if let isFemale = PFUser.current()? ["isFemale"] {
                
                query.whereKey("isIntrestedInWomen", equalTo: isFemale)
            }
            
            // if reject or acepted move to the next person in the swipe page you can choose
            
            var ignoreUsers : [String] = []
            
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] {
                ignoreUsers += acceptedUsers
            }
            
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String] {
                ignoreUsers += rejectedUsers
            }
            
            // query for the location longtued and alltitued
            
            query.whereKey("objectId", notContainedIn: ignoreUsers)
            if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint {
                
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geoPoint.latitude - 1, longitude: geoPoint.longitude - 1), toNortheast: PFGeoPoint(latitude: geoPoint.latitude + 1, longitude: geoPoint.longitude + 1))
                
                
            }
            
            
            query.limit = 1
            
            query.findObjectsInBackground { (objects, error) in
                
                if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            if let imageFile = user["photo"] as? PFFileObject {
                                
                                imageFile.getDataInBackground(block: { (data, error) in
                                    
                                    if let imageData = data {
                                        self.matchimageView.image = UIImage(data: imageData)
                                        if let objectID = object.objectId {
                                            self.displayUserID = objectID
                                       
                                        }
                                        
                                    }
                                })
                            }
                            
                        }
                    }
                }
                
            }
        }
    }
}
