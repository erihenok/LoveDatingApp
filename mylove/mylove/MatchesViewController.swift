//
//  MatchesViewController.swift
//  mylove
//
//  Created by Henok Welday on 5/22/20.
//  Copyright © 2020 Henok Welday. All rights reserved.
//

import UIKit
import Parse 

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell =  tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? MatchTableViewCell {
        cell.messageLabel.text = "You haven't received any message yet"
          return cell
        }
        return UITableViewCell()
    }

    @IBAction func backTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
