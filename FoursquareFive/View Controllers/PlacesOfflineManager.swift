//
//  PlacesOfflineManager.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 26.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//

import Foundation
import CoreData

/// This class is used to separate stuff like Core Data  and CoreLocation logic from View Controller for offline data fetch
class PlacesOfflineManager {
    var coreDataStack: CoreDataStack
    private var completionHandler:CompletionHandler?

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func fetchLocationDTO(completionHandler:@escaping CompletionHandler) {
        
        do {
            let context = self.coreDataStack.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<LocationDTO>(entityName: "Location")
            guard let location = try context.fetch(fetchRequest).first else {
                return
            }

            DispatchQueue.main.async {
                    completionHandler(location)
            }
        } catch {
            DispatchQueue.main.async {
                    completionHandler(nil)
            }
        }

    }
}
