//
//  FoursquareSecrets.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 26.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//

import Foundation

struct FoursquareSecrets: Codable {
    var clientSecret: String
    var clientId: String

    static func foursquareSecrets() -> FoursquareSecrets? {
        if let secretsPath = Bundle.main.path(forResource: "FoursquareSecrets", ofType: "plist"),
            let secretsData = FileManager.default.contents(atPath: secretsPath) {
            do {
                let secrets = try PropertyListDecoder().decode(FoursquareSecrets.self, from: secretsData)
                return secrets
            } catch {
                return nil
            }
        }
        return nil
    }
}
