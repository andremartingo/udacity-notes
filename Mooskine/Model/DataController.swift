//
//  DataController.swift
//  Mooskine
//
//  Created by André Martingo on 02/06/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

extension DataController{
    func autoSaveViewContext(interval:TimeInterval  = 30){
        print("autosaving")
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges{
            try? autoSaveViewContext(interval: interval)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+interval){
            self.autoSaveViewContext(interval: interval)
        }
    }
}
