//
//  LinkDetailsViewController.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import UIKit

class LinkDetailsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    var link: Link!
    
    var dataController:DataController!

    var onDelete: (() -> Void)?

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let createdAt = link.createdAt {
             navigationItem.title = dateFormatter.string(from: createdAt)
        }
        
        textView.text = link.title
        try? link.managedObjectContext?.save()
    }

    @IBAction func deleteLink(sender: Any) {
        presentDeleteLinkAlert()
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

extension LinkDetailsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        link.title = textView.text
        try? dataController.viewContext.save()
    }
}
