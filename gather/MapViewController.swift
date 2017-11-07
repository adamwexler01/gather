//
//  MasterViewController.swift
//  gather
//
//  Created by Adam Wexler on 11/6/17.
//  Copyright © 2017 Gather, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces


protocol MapViewControllerDelegate: class {
    func controllerDidPressLogoutButton(_ controller: MapViewController)
}

class MapViewController: UIViewController {
    
    public weak var delegate: MapViewControllerDelegate?

    init(delegate: MapViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didPressLogoutButton(_:)))
        
        navigationItem.rightBarButtonItem = logoutButton
        
        referenceFBData()
        let camera = GMSCameraPosition.camera(withLatitude: 29.6516, longitude: -82.3248, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 29.6516, longitude: -82.3248)
        marker.title = "Gainesville"
        marker.snippet = "Florida, USA"
        marker.map = mapView
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidLoad()
        super.viewDidAppear(true)
    }
    
    func didPressLogoutButton(_ sender: UIBarButtonItem) {
        delegate?.controllerDidPressLogoutButton(self)
    }
    
    func referenceFBData(){
        let request = FBSDKGraphRequest(graphPath:"me", parameters: ["fields":"email,first_name,gender"]);
        
        request?.start(completionHandler: { (connection, result, error) in
            if(error != nil){
                print("This is the seen error: \(String(describing: error))")
            } else {
                print("This is the result that you are looking for: \(String(describing: result))")
            }
        })
        
    }
}
