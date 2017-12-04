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
import Unbox

protocol MapViewControllerDelegate: class {
    func controllerDidPressLogoutButton(_ controller: MapViewController)
    func controller(_ controller: MapViewController, didPressListButtonWith events: [Event])
}

class MapViewController: UIViewController {
    
    public weak var delegate: MapViewControllerDelegate?
    var events: [Event] = [] {
        didSet {
            updateEvents(events)
        }
    }

    
    let camera = GMSCameraPosition.camera(withLatitude: 29.6516, longitude: -82.3248, zoom: 12.5)
    lazy var mapView: GMSMapView = GMSMapView.map(withFrame: CGRect.zero, camera: self.camera)

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
        let toggleButton = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(didPressListButton(_:)))
        
        navigationItem.rightBarButtonItem = logoutButton
        navigationItem.leftBarButtonItem = toggleButton
        
        self.view = mapView
    }
    

    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidLoad()
        super.viewDidAppear(true)
    }
    
    func didPressLogoutButton(_ sender: UIBarButtonItem) {
        delegate?.controllerDidPressLogoutButton(self)
    }
    
    func didPressListButton(_ sender: UIBarButtonItem){
        delegate?.controller(self, didPressListButtonWith: events)
    }
    

    
    func updateEvents(_ events: [Event]) {
        
        mapView.clear()
        
        for event in events {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: event.place.location.latitude, longitude: event.place.location.longitude)
            marker.title = event.name
            marker.snippet = event.description
            marker.map = mapView
            print(event.name)
            print(event.place.location.latitude)
            print(event.place.location.longitude)
        }
        
    }
    
    func handleError(_ error: Error) {
        print(error)
    }
}

struct Place: Unboxable {
    
    // name
    let location: Location
    
    init(unboxer: Unboxer) throws {
        location = try unboxer.unbox(key: "location")
    }
}

struct Location: Unboxable {
    
    let latitude: Double
    let longitude: Double

    init(unboxer: Unboxer) throws {
        latitude = try unboxer.unbox(key: "latitude")
        longitude = try unboxer.unbox(key: "longitude")
    }
}
struct Event: Unboxable {
    
    let name: String?
    let startTime: Date?
    let date: Date?
    let description: String?
    let place: Place

    init(unboxer: Unboxer) throws {

        place = try unboxer.unbox(key: "place")
        startTime = try? unboxer.unbox(key: "start_time", formatter: DateFormatter.originalDateFormatter)
        name = try? unboxer.unbox(key: "name")
        date = try? unboxer.unbox(key: "date", formatter: DateFormatter.fixedDateFormatter)
        description = try? unboxer.unbox(key: "description")
    }
}


extension DateFormatter {
    static var originalDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SSSS"
        return formatter
    }
    
    static var fixedDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy - 'START TIME-' HH:mm"
        return formatter
    }
}

