//
//  PlacesViewController.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 24.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Network

class PlacesViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placesTable: UITableView!

    private let locationManager = CLLocationManager()
    private let coreDataStack = CoreDataStack()
    private var fetchedResultController: NSFetchedResultsController<LocationDTO>!

    private lazy var placesOnlineManager: PlacesOnlineManager = {
        return PlacesOnlineManager(coreDataStack: coreDataStack)
    }()

    private lazy var placesOfflineManager: PlacesOfflineManager = {
        return PlacesOfflineManager(coreDataStack: coreDataStack)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        placesTable.delegate = self
        placesTable.dataSource = self
        createFetchResultController()

        loadData()
    }

    @IBAction func updateLocation(_ sender: Any) {
        self.requestLocation()
        self.loadData()
    }

    private func loadData() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.requestLocation()
                self.placesOnlineManager.fetchLocationDTO(from: self.locationManager.location!) {  location in
                    guard let location = location else {
                        self.presetErrorAlert()
                        return
                    }
                    
                    self.addressLabel.text = location.getPrettyLocation()
                    self.placesTable.reloadData()
                }
            } else {
                self.placesOfflineManager.fetchLocationDTO { ( location) in
                    guard let location = location else {
                        self.presetErrorAlert()
                        return
                    }
                    
                    self.addressLabel.text = location.getPrettyLocation()
                    self.placesTable.reloadData()
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    private func createFetchResultController() {
        if fetchedResultController == nil {
            let request = NSFetchRequest<LocationDTO>(entityName: "Location")
            request.sortDescriptors = []
            request.fetchBatchSize = 1

            fetchedResultController =
                NSFetchedResultsController(
                    fetchRequest: request,
                    managedObjectContext: coreDataStack.persistentContainer.viewContext,
                    sectionNameKeyPath: nil,
                    cacheName: nil)
            fetchedResultController.delegate = self
        }

        do {
            try fetchedResultController.performFetch()
            placesTable.reloadData()
        } catch {
            fatalError("Cannot create NSFetchResultController")
        }
    }

    private func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    private func presetErrorAlert(){
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: "Oops, something went wrong!", message: nil, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertViewController.addAction(okAction)

            self.present(alertViewController, animated: true, completion: nil)
        }
    }
}

extension PlacesViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Update location")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension PlacesViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        self.placesTable.reloadData()
    }

}

extension PlacesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let locationObject = fetchedResultController.sections![section].objects?.first as? LocationDTO,
            let count = locationObject.venues?.count {
            return count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath)
        let location = fetchedResultController.object(at: IndexPath(item: 0, section: 0))
        if let set = location.venues as? Set<VenueDTO> {
            let array = Array(set)
            cell.textLabel?.text = array[indexPath.row].name
        }

        return cell
    }
}
