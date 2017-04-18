//
//  CoreDataStack.swift
//  Photorama
//
//  Created by Rahul Ranjan on 4/18/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    let managedObjectModelName: String
    
    // NSManagedObjectModel is the filename where we
    // defined our all properties
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // Perisitence Coordinator
    // SQLite, XML, Atomic, In-memory
    private var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first! as NSURL
    }()
    
    private lazy var persistenceStoreCoordinator: NSPersistentStoreCoordinator = {
        
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let pathComponent = "\(self.managedObjectModelName).sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(pathComponent)
        
        let store = try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        
        return coordinator
    }()
    
    // NSManagedObjectContext
    lazy var mainQueueContext: NSManagedObjectContext = {
       
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistenceStoreCoordinator
        moc.name = "Main Queue Context (UI Context)"
        
        return moc
    }()
    
    required init(modelName: String) {
        managedObjectModelName = modelName
    }
    
    
}
