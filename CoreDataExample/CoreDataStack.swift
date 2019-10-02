//
//  CoreDataStack.swift
//  CoreDataExample
//
//  Created by SeokHo on 2019/10/02.
//  Copyright © 2019 SeokHo. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private init() { }
    
    static let manager = CoreDataStack()
    
    lazy var managedObectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "CoreDataExample", withExtension: "momd") else {
            preconditionFailure()
        }
        
        guard let managedObectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            preconditionFailure()
        }
        
        return managedObectModel
    }()
    
    lazy var persistentstoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentstroeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObectModel)
        
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            preconditionFailure()
        }
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent("CoreDataExample.sqlite")
        
        do {
            try persistentstroeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
        } catch {
            print(error.localizedDescription)
        }
        
        return persistentstroeCoordinator
    }()
    
    lazy var managedObjectcontext: NSManagedObjectContext = {
        let managedObjectcontext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectcontext.persistentStoreCoordinator = persistentstoreCoordinator
        managedObjectcontext.automaticallyMergesChangesFromParent = true
        return managedObjectcontext
    }()
    
}
