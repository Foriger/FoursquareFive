//
//  LocationDTO+CoreDataProperties.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 26.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//
//

import Foundation
import CoreData

extension LocationDTO {

    @nonobjc public class func locationFetchRequest() -> NSFetchRequest<LocationDTO> {
        return NSFetchRequest<LocationDTO>(entityName: "Location")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var name: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var venues: NSSet?

}

// MARK: Generated accessors for venues
extension LocationDTO {

    @objc(addVenuesObject:)
    @NSManaged public func addToVenues(_ value: VenueDTO)

    @objc(removeVenuesObject:)
    @NSManaged public func removeFromVenues(_ value: VenueDTO)

    @objc(addVenues:)
    @NSManaged public func addToVenues(_ values: NSSet)

    @objc(removeVenues:)
    @NSManaged public func removeFromVenues(_ values: NSSet)

}
