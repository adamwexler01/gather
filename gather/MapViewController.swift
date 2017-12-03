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
}

class MapViewController: UIViewController {
    
    public weak var delegate: MapViewControllerDelegate?
    
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
        
        navigationItem.rightBarButtonItem = logoutButton
        
        referenceFBData()
        let mapData = getLocationIDs()
        print(mapData)
        self.view = mapView
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
    func getLocationIDs() {
        
        FBSDKGraphRequest(graphPath: "/search", parameters: ["pretty": "0", "type": "place", "center": "29.651634,-82.324829", "distance": "45000", "limit": "100", "fields": "id"], httpMethod: "GET").start(completionHandler: { [weak self] (connection, result, error) -> Void in
            guard let `self` = self else { return }
            
            if let error = error {
                self.handleError(error)
            } else {
                //print(result)
                let placeDict = result as! NSDictionary
                let placeIDs = placeDict.object(forKey: "data") as! NSArray
                var ids = [String]()
                var count = 0
                for singleDictEntry in placeIDs{
                    if(count < 49){
                        ids.append((singleDictEntry as AnyObject).object(forKey: "id") as! String)
                        count += 1
                    } else{
                        break
                    }
                }
                let stringIDs = ids.joined(separator: ", ")
                var parametersForPlaces = [String: Any]()
                parametersForPlaces["ids"] = stringIDs
                
                self.getEvents(parameters: parametersForPlaces)
            }
        })
    }
    
    func getEvents(parameters: [String: Any]) {

        FBSDKGraphRequest(graphPath: "/events", parameters: parameters, httpMethod: "GET").start(completionHandler: { [weak self] (connection, result, error) -> Void in
            
            guard let `self` = self else { return }
            
            if let error = error {
                
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.handleError(error)
                }

                return
            }
            
            guard let resultDict = result as? UnboxableDictionary else {
                return
            }
            
            let eventsArrays = resultDict.map { (arg) -> [Event] in
                let (_, value) = arg
                let placeDict = value as? [String: Any] ?? [:]
                let eventDicts = placeDict["data"] as? [[String: Any]]
                let events: [Event]? = try? unbox(dictionaries: eventDicts ?? [])
                return events ?? []
            }
            
            let events = eventsArrays.flatMap { $0 }
            
            
            
            
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.handleResponse(events)
            }
        })
    }
    
    func handleResponse(_ events: [Event]) {
        
        let currentDate = Date()
//        let events = response.events
//
//        print(events)
        
        let filteredEvents = events.filter { $0.startTime?.compare(currentDate) == .orderedDescending }
        
        
        for event in filteredEvents {
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

