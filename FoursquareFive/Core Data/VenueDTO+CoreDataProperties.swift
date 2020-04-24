//
//  VenueDTO+CoreDataProperties.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 26.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//
//

import Foundation
import CoreData

extension VenueDTO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VenueDTO> {
        return NSFetchRequest<VenueDTO>(entityName: "Venue")
    }

    @NSManaged public var name: String?
    @NSManaged public var location: LocationDTO?

}
