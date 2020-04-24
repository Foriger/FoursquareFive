//
//  LocationDTO+CoreDataClass.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 26.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(LocationDTO)
public class LocationDTO: NSManagedObject {

    class func createFrom(placemark: CLPlacemark, context: NSManagedObjectContext) {
        let location = LocationDTO(context: context)
        location.city = placemark.locality
        location.name = placemark.name
        location.country = placemark.country
        location.lat = (placemark.location?.coordinate.latitude ?? 0)
        location.lon = (placemark.location?.coordinate.longitude ?? 0)
    }

    func getPrettyLocation() -> String {
        var labelText = ""
        if let name = self.name {
            labelText += name
        }
        if let city = city {
            if labelText.isEmpty {
                labelText += city
            } else {
                labelText += ", \(city)"
            }
        }
        if let country = country {
            if labelText.isEmpty {
                labelText += country
            } else {
                labelText += ", \(country)"
            }
        }
        return labelText
    }

}
