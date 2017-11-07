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
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    func start() {
        print(FBSDKAccessToken.current())
        print(FBSDKAccessToken.current()?.tokenString)
        if FBSDKAccessToken.current() != nil {
            presentMapFlow()
        } else {
            presentAuthFlow()
        }
    }
    
    func presentAuthFlow() {
        let controller = ViewController(delegate: self)
        window.rootViewController = controller
    }
    
    func presentMapFlow() {
        let controller = MapViewController(delegate: self)
        let navController = UINavigationController(rootViewController: controller)
        window.rootViewController = navController
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
}


extension AppCoordinator: ViewControllerDelegate {
    func controller(_ controller: ViewController, didCompleteWithResult result: FBSDKLoginManagerLoginResult?, error: Error?) {
        
        if let error = error {
            presentError(in: controller)
        } else if let result = result {
            
            if result.token != nil {
                presentMapFlow()
            } else {
                presentError(in: controller)
            }
            
        } else {
            print("idk")
        }
        
        UserDefaults.standard.synchronize()
    }
}
