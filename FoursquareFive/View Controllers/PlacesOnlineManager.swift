//
//  PlacesOnlineManager.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 26.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//

import Foundation
import CoreLocation

typealias CompletionHandler = (LocationDTO?) -> Void

/// This class is used to separate stuff like Core Data  and CoreLocation logic from View Controller for online data fetch
class PlacesOnlineManager : NSObject {

    var coreDataStack: CoreDataStack
    var completionHandler: CompletionHandler?

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func fetchLocationDTO(from clLocation: CLLocation,
                          completionHandler:@escaping CompletionHandler) {
        
        self.completionHandler = completionHandler
        
        getLocationDTOFromLocation(location: clLocation)
    }
    
    
    private func getLocationDTOFromLocation(location: CLLocation) {
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if error == nil {
                if let firstLocation = placemarks!.first {

                    let context = self.coreDataStack.persistentContainer.viewContext
                    self.coreDataStack.batchDeleteFor(fetchRequest: LocationDTO.fetchRequest())

                    LocationDTO.createFrom(placemark: firstLocation, context: context)
                    self.coreDataStack.saveContext()
                    self.getLocationVenues()
                }
            } else {
                self.callCompletionHandler(location: nil)
            }
        }
    }

    private func getLocationVenues() {
        self.coreDataStack.persistentContainer.viewContext.reset()

        let context = self.coreDataStack.persistentContainer.viewContext
        let fetchRequest = LocationDTO.locationFetchRequest()

        do {
            guard let location = try context.fetch(fetchRequest).first else {
                return
            }

            let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            API().getPlacesFor(coordinate: coordinate ) { venues in
                for venue in venues {
                    let object = VenueDTO(context: context)
                    object.name = venue.name
                    location.addToVenues(object)
                }

                self.coreDataStack.saveContext()
                self.callCompletionHandler(location: location)
            }
        } catch {
            self.callCompletionHandler(location: nil)
        }
    }
    
    private func callCompletionHandler(location:LocationDTO?){
        if let completionHandler = completionHandler {
            DispatchQueue.main.async {
                completionHandler(location)
            }
        }
    }
}

