//
//  SettingsViewController.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 22/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func clearAllData(_ sender: Any) {
        let alert = UIAlertController(title: "Clear all data", message: "Do you want to clear all your data?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteHandler(alertAction: UIAlertAction) {
        //clearAllData
    }
}
