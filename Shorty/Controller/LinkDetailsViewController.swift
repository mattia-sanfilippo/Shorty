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

    @IBOutlet weak var linkTitle: UITextField!
    @IBOutlet weak var shortenedLink: UITextField!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var linkFullUrl: UITextView!
    var dataController:DataController!

    var onDelete: (() -> Void)?
    
    var onSave: (() -> Void)?

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkTitle.text = link.title
        shortenedLink.text = "https://rel.ink/" + (link.hashid)!
        createdAt.text = dateFormatter.string(from: link.createdAt!)
        linkFullUrl.text = link.url
        
        try? link.managedObjectContext?.save()
    }

    @IBAction func deleteLink(sender: Any) {
        presentDeleteLinkAlert()
    }
    @IBAction func openLink(_ sender: Any) {
        if let url = URL(string: shortenedLink.text ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        onSave?()
    }
    
}

// -----------------------------------------------------------------------------
// MARK: - Editing

extension LinkDetailsViewController {
    func presentDeleteLinkAlert() {
        let alert = UIAlertController(title: "Delete Link", message: "Do you want to delete this link?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler))
        present(alert, animated: true, completion: nil)
    }

    func deleteHandler(alertAction: UIAlertAction) {
        onDelete?()
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITextViewDelegate

extension LinkDetailsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        link.title = textField.text
        try? dataController.viewContext.save()
    }
}

extension LinkDetailsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        link.title = textView.text
        try? dataController.viewContext.save()
    }
}
