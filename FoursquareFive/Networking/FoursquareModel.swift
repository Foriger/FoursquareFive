//
//  FoursquareModel.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 25.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//

import Foundation

struct FoursquareResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let venues: [VenueResponse]
}

struct VenueResponse: Codable {
    let name: String
}
