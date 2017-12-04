//
//  AppCoordinator.swift
//  gather
//
//  Created by Adam Wexler on 11/7/17.
//  Copyright © 2017 Gather, Inc. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit

class AppCoordinator: NSObject {
    
    lazy var authViewController: ViewController = ViewController(delegate: self)
    lazy var mapViewController: MapViewController = MapViewController(delegate: self)
    lazy var listViewController: ListViewController = ListViewController()

    fileprivate let navigationController: UINavigationController
    fileprivate let store: Store
    
    init(navigationController: UINavigationController, store: Store) {
        self.navigationController = navigationController
        self.store = store
        super.init()
    }
    
    var events: [Event] = [] {
        didSet {
            mapViewController.events = events
            listViewController.events = events
        }
    }
    
    func start() {
        print(FBSDKAccessToken.current())
        print(FBSDKAccessToken.current()?.tokenString)
        if FBSDKAccessToken.current() != nil {
            updateEvents()
            presentMapFlow()
        } else {
            events = []
            presentAuthFlow()
        }
    }
    
    func updateEvents() {
        store.getEvents { events in
            let currentDate = Date()
            let filteredEvents = events.filter { $0.startTime?.compare(currentDate) == .orderedDescending }
            self.events = filteredEvents
        }
    }
    
    
    func presentAuthFlow() {
        navigationController.setViewControllers([authViewController], animated: false)
        navigationController.isNavigationBarHidden = true
        
    }
    
    func presentMapFlow() {
        navigationController.setViewControllers([mapViewController], animated: false)
        navigationController.isNavigationBarHidden = false
    }
    
    func presentError(in controller: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}

extension AppCoordinator: MapViewControllerDelegate {

    func controllerDidPressLogoutButton(_ controller: MapViewController) {
        FBSDKAccessToken.setCurrent(nil)
        start()
    }
    
    func controller(_ controller: MapViewController, didPressListButtonWith events: [Event]) {
        navigationController.pushViewController(listViewController, animated: true)
    }
}


extension AppCoordinator: ViewControllerDelegate {
    func controller(_ controller: ViewController, didCompleteWithResult result: FBSDKLoginManagerLoginResult?, error: Error?) {
        
        if let error = error {
            presentError(in: controller)
        } else if let result = result {
            if result.token != nil {
                start()
            } else {
                presentError(in: controller)
            }
        } else {
            print("idk")
        }
        
        UserDefaults.standard.synchronize()
    }
}
