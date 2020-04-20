//
//  ShortyViewController.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import UIKit

class ShortyViewController: UIViewController {
    
    var dataController:DataController!
    
    // MARK: Outlets
    
    @IBOutlet weak var urlField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        // MARK: Hide keyboard on tap outside the URL Text Field
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
    }

    @IBAction func makeItShorty(_ sender: Any) {
        RelinkClient.addLink(longUrl: urlField.text ?? "") { (response, error) in
            self.dataController.addLink(title: "New Link", url: self.urlField.text ?? "", hashid: response)
        }
    }
    
}

