//
//  ShortyViewController.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import UIKit
import Comets

class ShortyViewController: UIViewController {
    
    var dataController:DataController!
    
    // MARK: Outlets
    
    @IBOutlet weak var urlField: UITextField!
    
    fileprivate func showComets() {
        // Customize your comet
        let width = view.bounds.width
        let height = view.bounds.height
        let comets = [Comet(startPoint: CGPoint(x: 100, y: 0),
                            endPoint: CGPoint(x: 0, y: 100),
                            lineColor: UIColor.systemTeal.withAlphaComponent(0.2),
                            cometColor: UIColor.systemTeal),
                      Comet(startPoint: CGPoint(x: 0.4 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.8 * width),
                            lineColor: UIColor.systemTeal.withAlphaComponent(0.2),
                            cometColor: UIColor.systemTeal),
                      Comet(startPoint: CGPoint(x: 0.8 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.2 * width),
                            lineColor: UIColor.systemTeal.withAlphaComponent(0.2),
                            cometColor: UIColor.systemTeal),
                      Comet(startPoint: CGPoint(x: width, y: 0.2 * height),
                            endPoint: CGPoint(x: 0, y: 0.25 * height),
                            lineColor: UIColor.systemTeal.withAlphaComponent(0.2),
                            cometColor: UIColor.systemTeal),
                      Comet(startPoint: CGPoint(x: 0, y: height - 0.8 * width),
                            endPoint: CGPoint(x: 0.6 * width, y: height),
                            lineColor: UIColor.systemTeal.withAlphaComponent(0.2),
                            cometColor: UIColor.systemTeal),
                      Comet(startPoint: CGPoint(x: width - 100, y: height),
                            endPoint: CGPoint(x: width, y: height - 100),
                            lineColor: UIColor.systemTeal.withAlphaComponent(0.2),
                            cometColor: UIColor.systemTeal),
                      Comet(startPoint: CGPoint(x: 0, y: 0.8 * height),
                            endPoint: CGPoint(x: width, y: 0.75 * height),
                            lineColor: UIColor.systemTeal.withAlphaComponent(0.2),
                            cometColor: UIColor.systemTeal)]
        
        // draw line track and animate
        for comet in comets {
            view.layer.addSublayer(comet.drawLine())
            view.layer.addSublayer(comet.animate())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        // MARK: Hide keyboard on tap outside the URL Text Field
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
        
        showComets()
    }

    @IBAction func makeItShorty(_ sender: Any) {
        RelinkClient.addLink(longUrl: urlField.text ?? "") { (response, error) in
            let saved = self.dataController.addLink(title: "New Link", url: self.urlField.text ?? "", hashid: response)
            if (saved){
                self.performSegue(withIdentifier: "goToLinksList", sender: self)
            }
            
        }
    }
    
    
    
    
}

