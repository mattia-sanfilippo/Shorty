//
//  DataController.swift
//  Shorty
//
//  Created by Mattia Sanfilippo on 18/04/2020.
//  Copyright © 2020 Mattia Sanfilippo. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext(interval: 3)
            completion?()
        }
    }
    
    func addLink(title: String, url: String, hashid: String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Link", in: viewContext)
        let newLink = Link(entity: entity!, insertInto: viewContext)
        newLink.title = title
        newLink.url = url
        newLink.hashid = hashid
        
        if newLink.hashid == "" {
            return false
        }
        
        do {
            try viewContext.save()
        } catch let error {
            print("Error while saving hashid: \(newLink.hashid!) in memory")
            print("Error: \(error)")
            return false
        }
        
        print("Data saved!")
        return true
    }
}

extension DataController {
    func autoSaveViewContext(interval:TimeInterval = 2){
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
