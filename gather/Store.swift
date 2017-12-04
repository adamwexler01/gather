//
//  Store.swift
//  gather
//
//  Created by Adam Wexler on 12/3/17.
//  Copyright © 2017 Gather, Inc. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Unbox


enum Result<T> {
    case error(Error)
    case value(T)
}

class Store: NSObject {
    
    func getEvents(completion: @escaping ([Event]) -> Void) {
        getLocationIDs { [weak self] result in
            guard let `self` = self else {
                completion([])
                return
            }
            
            switch result {
            case .error:
        
                completion([])
        
            case .value(let ids):
                
                self.getEvents(parameters: ids) { eventsResult in
                    
                    switch eventsResult {
                    case .error:
                        completion([])
                    case .value(let events):
                        completion(events)
                    }
                }
            }
        }
    }
    
    private func getLocationIDs(completion: @escaping (Result<[String: Any]>) -> Void) {
        
        FBSDKGraphRequest(graphPath: "/search", parameters: ["pretty": "0", "type": "place", "center": "29.651634,-82.324829", "distance": "45000", "limit": "100", "fields": "id"], httpMethod: "GET").start(completionHandler: { (connection, result, error) -> Void in
            
            if let error = error {
                completion(.error(error))
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
            
                completion(.value(parametersForPlaces))
            }
        })
    }
    
    private func getEvents(parameters: [String: Any], completion: @escaping (Result<[Event]>) -> Void) {
        
        FBSDKGraphRequest(graphPath: "/events", parameters: parameters, httpMethod: "GET").start(completionHandler: { (connection, result, error) -> Void in
            
            
            if let error = error {
                completion(.error(error))
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
            
            completion(.value(events))
        })
    }

    
}
