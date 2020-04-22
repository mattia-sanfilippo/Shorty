//
//  LinkDetailsViewController.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import UIKit

class LinkDetailsViewController: UIViewController {

    var link: Link!

    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var linkTitle: UITextField!
    @IBOutlet weak var shortenedLink: UITextField!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var linkFullUrl: UITextView!
    var dataController:DataController!

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.title = link.title
        linkTitle.text = link.title
        shortenedLink.text = "https://rel.ink/" + (link.hashid)!
        createdAt.text = dateFormatter.string(from: link.createdAt!)
        linkFullUrl.text = link.url
        
        try? link.managedObjectContext?.save()
    }

    @IBAction func openLink(_ sender: Any) {
        if let url = URL(string: shortenedLink.text ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func copyLink(_ sender: Any) {
        UIPasteboard.general.string = shortenedLink.text
        showAlert(message: "Link has been copied successfully!", title: "Copied")
    }
    
    fileprivate func showShareLinkVC(_ url: URL) {
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareLink(_ sender: Any) {
        if let url = URL(string: shortenedLink.text ?? "") {
            showShareLinkVC(url)
        }
    }
    
    @IBAction func closeLink(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
