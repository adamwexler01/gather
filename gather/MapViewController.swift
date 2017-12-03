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
        getLocationIDs()
        let camera = GMSCameraPosition.camera(withLatitude: 29.6516, longitude: -82.3248, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
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
    func getLocationIDs(){
        FBSDKGraphRequest(graphPath: "/search", parameters: ["pretty": "0", "type": "place", "center": "29.651634,-82.324829", "distance": "45000", "limit": "100", "fields": "id"], httpMethod: "GET").start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
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
                FBSDKGraphRequest(graphPath: "/events", parameters: parametersForPlaces, httpMethod: "GET").start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let resultDict = result as! NSDictionary
                        for key in resultDict.allKeys {
                            let stringKey = key as! String
                            if (resultDict.object(forKey: stringKey) != nil){
                                let testDict = resultDict.object(forKey: stringKey) as! NSDictionary
                                let data = testDict.object(forKey: "data") as! NSArray
                                print(data)
                                
                                let originalDateFormatter = DateFormatter()
                                originalDateFormatter.dateFormat = "yyyy-MM-dd"
                                
//                                let fixedDateFormatter = DateFormatter()
//                                fixedDateFormatter.dateFormat = "MMM dd,yyyy"
                                
//                                if(data.count > 0){
//                                    let startDate =
//                                    let name1 = (data[0] as AnyObject).object(forKey: "name") as! String
//                                    print(name1)
//                                }
                                for dts in data {
                                    var startTime = (dts as AnyObject).object(forKey: "start_time") as! String
                                    startTime = originalDateFormatter.string(from: startTime)
                                    let name = (dts as AnyObject).object(forKey: "name") as! String
                                    print(name)
                                }
                            }
                        }
//                        var testDict = resultDict.object(forKey: "107173749306996") as! NSDictionary
//                        //print(result as Any)
//                        var data = testDict.object(forKey: "data") as! NSArray
//                        let name = (data.object(at: 0) as AnyObject).object(forKey: "name") as! String
//                        print(name)
                    }
                })
                
            } else{
                print("error is \(error)")
            }
        })
    }
}
