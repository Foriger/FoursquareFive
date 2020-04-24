//
//  MainViewController.swift
//  FoursquareFive
//
//  Created by Radoslav Penev on 24.04.20.
//  Copyright © 2020 Radoslav Penev. All rights reserved.
//

import UIKit

class MainViewController: UIPageViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    private lazy var placesViewController: PlacesViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyBoard.instantiateViewController(identifier: "PlacesViewController") as! PlacesViewController

        return vc
    }()

    private lazy var aboutUsViewController: AboutUsViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyBoard.instantiateViewController(identifier: "AboutUsViewController") as! AboutUsViewController

        return vc
    }()

    func setViewControllerForIndex(index: Int) {
      setViewControllers(
        [index == 0 ? placesViewController : aboutUsViewController],
        direction: .forward,
        animated: false,
        completion: nil
      )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllerForIndex(index: 0)
    }

    @IBAction func segmentTouched(_ sender: UISegmentedControl) {
        setViewControllerForIndex(index: sender.selectedSegmentIndex)
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if viewController == placesViewController {
            return aboutUsViewController
        }
        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == placesViewController {
            return aboutUsViewController
        }
        return nil
    }
}
