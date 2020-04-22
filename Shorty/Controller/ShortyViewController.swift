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
    @IBOutlet weak var makeItShortyButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        // MARK: Hide keyboard on tap outside the URL Text Field
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UserDefaults.standard.bool(forKey: "animation")){
            showComets()
        }
    }

    @IBAction func makeItShorty(_ sender: Any) {
        newLinkAlert()
    }
    
    func newLinkAlert() {
        let alert = UIAlertController(title: "New Link", message: "Enter a name for this fantastic link!", preferredStyle: .alert)

        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.handleAddLink(name: name)
            }
        }
        saveAction.isEnabled = false

        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "New link"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func handleAddLink(name: String){
        if (verifyUrl(urlString: urlField.text)){
            handleUI(enabled: false)
            RelinkClient.addLink(longUrl: urlField.text ?? "") { (response, error) in
                if (response != ""){
                    if (self.dataController.addLink(title: name, url: self.urlField.text ?? "", hashid: response)){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                        self.performSegue(withIdentifier: "goToLinksList", sender: self)
                        self.handleUI(enabled: true)
                    }
                }
            }
        }
        else {
            showAlert(message: "Please insert a valid URL!", title: "Error")
        }
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    
    
    func handleUI(enabled: Bool) {
        if enabled {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.makeItShortyButton.isEnabled = enabled
                self.urlField.isEnabled = enabled
                self.urlField.text = ""
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.makeItShortyButton.isEnabled = enabled
                self.urlField.isEnabled = enabled
            }
        }
    }
    
    fileprivate func showComets() {
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
        
        for comet in comets {
            view.layer.addSublayer(comet.drawLine())
            view.layer.addSublayer(comet.animate())
        }
    }
}
