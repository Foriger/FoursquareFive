//
//  CoreDataStack.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 25.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//

import CoreData

class CoreDataStack {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FoursquareFive")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func batchDeleteFor(fetchRequest: NSFetchRequest<NSFetchRequestResult>) {

        let context = self.persistentContainer.viewContext
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            self.persistentContainer.viewContext.reset()
            self.persistentContainer.viewContext.refreshAllObjects()
        } catch {
            print(error)
        }
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
