//
//  SettingsViewController.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 22/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var animationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationFlag = UserDefaults.standard.bool(forKey: "animation")
        
        animationSwitch.setOn(animationFlag, animated: false)
    }
    
    
    @IBAction func toggleAnimationSwitch(_ sender: Any) {
        UserDefaults.standard.set(animationSwitch.isOn, forKey: "animation")
        if(!animationSwitch.isOn){
            showAlert(message: "Restart your app in order to apply this change!", title: "Notice")
        }
    }
    
    @IBAction func openGitHub(_ sender: Any) {
        if let url = URL(string: "https://github.com/mattia-sanfilippo") {
            UIApplication.shared.open(url)
        }
    }
}
