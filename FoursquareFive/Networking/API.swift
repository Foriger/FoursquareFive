//
//  API.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 24.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//

import Foundation
import CoreLocation

enum APIError: Error {
    case noData
    case badResponse(statusCode: Int)
    case internalError(error: Error)
    case parsingError(error: Error)
}

class API {

    private var foursquareURL = URL(string: "https://api.foursquare.com/")

    func getPlacesFor( coordinate: CLLocationCoordinate2D,
                       completionHandler:@escaping ([VenueResponse])->Void) {
        guard let secrets = FoursquareSecrets.foursquareSecrets() else {
            fatalError("Foursquare Secrets aren't provided")
        }

        guard let foursquareURL = foursquareURL else {
            fatalError("Foursquare URL is wrong")
        }

        guard var foursquareURLComponents = URLComponents(
            url: foursquareURL,
            resolvingAgainstBaseURL: false) else {
                fatalError("Foursquare URLComponents failed")
            }
        foursquareURLComponents.path = "/v2/venues/search"

        foursquareURLComponents.queryItems = [
            URLQueryItem(name: "ll", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "v",
                         value: "20200424"),
            URLQueryItem(name: "client_id",
                         value: secrets.clientId),
            URLQueryItem(name: "client_secret",
                         value: secrets.clientSecret),
            URLQueryItem(name: "limit",
                         value: "5")
        ]

        guard let requestURL = foursquareURLComponents.url else {
            fatalError("no request url")
        }

        executeHTTPRequest(request: URLRequest(url: requestURL)) { (response: FoursquareResponse?, _: APIError?) in
            if let response = response {
                DispatchQueue.main.async {
                    completionHandler(response.response.venues)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }

    private func executeHTTPRequest<T: Codable>(request: URLRequest, finish: @escaping (T?, APIError?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    if let data = data {
                        print(String(data: data, encoding: .utf8)!)
                    }
                    DispatchQueue.main.async {
                        finish(nil, .badResponse(statusCode: response.statusCode))
                    }
                    return
                }
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    finish(nil, .noData)
                }
                return
            }

            if error != nil {
                DispatchQueue.main.async {
                    finish(nil, .internalError(error: error!))
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970

            do {
                let dict = try jsonDecoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    finish(dict, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    finish(nil, .parsingError(error: error))
                }
            }
        }
        task.resume()
    }

}
