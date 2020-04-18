//
//  LinksListViewController.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import UIKit
import CoreData

class LinksListViewController: UIViewController, UITableViewDataSource {
    /// A table view that displays a list of notes for a notebook
    @IBOutlet weak var tableView: UITableView!

    /// The notebook whose notes are being displayed
    var dataController: DataController!
    
    var links:[Link] = []

    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest:NSFetchRequest<Link> = Link.fetchRequest()
        //let predicate = NSPredicate(format: "notebook == %@", notebook)
        //fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            links = result
            tableView.reloadData()
        }
        navigationItem.title = ""
        navigationItem.rightBarButtonItem = editButtonItem
        updateEditButtonState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions

    @IBAction func addTapped(sender: Any) {
        addNote()
    }

    // -------------------------------------------------------------------------
    // MARK: - Editing

    // Adds a new `Note` to the end of the `notebook`'s `notes` array
    func addNote() {
        let link = Link(context: dataController.viewContext)
        link.title = "New Link"
        link.createdAt = Date()
        try? dataController.viewContext.save()
        links.insert(link, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        updateEditButtonState()
    }

    // Deletes the `Note` at the specified index path
    func deleteNote(at indexPath: IndexPath) {
        let linkToDelete = link(at: indexPath)
        links.remove(at: indexPath.row)
        dataController.viewContext.delete(linkToDelete)
        try? dataController.viewContext.save()
        tableView.deleteRows(at: [indexPath], with: .fade)
        if numberOfNotes == 0 {
            setEditing(false, animated: true)
        }
        updateEditButtonState()
    }

    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = numberOfNotes > 0
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // -------------------------------------------------------------------------
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfNotes
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aLink = link(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: LinkCells.defaultReuseIdentifier, for: indexPath) as! LinkCells

        // Configure cell
        cell.titleLabel.text = aLink.title
        cell.urlLabel.text = aLink.url
        /*if let createdAt = aLink.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAt)
        }*/
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNote(at: indexPath)
        default: () // Unsupported
        }
    }

    // Helpers

    var numberOfNotes: Int { return links.count }

    func link(at indexPath: IndexPath) -> Link {
        return links[indexPath.row]
    }

    // -------------------------------------------------------------------------
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NoteDetailsViewController, we'll configure its `Note`
        // and its delete action
        if let vc = segue.destination as? LinkDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.link = link(at: indexPath)
                vc.dataController = dataController
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.deleteNote(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
