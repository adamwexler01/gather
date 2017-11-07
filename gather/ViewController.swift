//
//  ViewController.swift
//  gather
//
//  Created by Adam Wexler on 9/25/17.
//  Copyright © 2017 Gather, Inc. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces
import ChameleonFramework

protocol ViewControllerDelegate: class {
    func controller(_ controller: ViewController, didCompleteWithResult result: FBSDKLoginManagerLoginResult?, error: Error?)
}

class ViewController: UIViewController {
    
    public weak var delegate: ViewControllerDelegate?
    
    init(delegate: ViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
=======
        // Do any additional setup after loading the view, typically from a nib.

        if (FBSDKAccessToken.current()) != nil {
            //User already has access to the api/connected to facebook
            //So we can just generate the account information from
            //the facebook api
            loginFBData()
//            referenceFBData()
            getLocationIDs()
            
        } else {
            let button = FBSDKLoginButton()
            button.sizeThatFits(CGSize(width: CGFloat(100), height: CGFloat(50)))
            button.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height*9/10)
            self.view.addSubview(button)
        }
>>>>>>> 2a2f72247a57d29d0d141666a9d794e628cf09a9
        
        let button = FBSDKLoginButton()
        button.delegate = self
        
        let backgroundColor = UIColor.flatYellow()
        
        button.sizeThatFits(CGSize(width: CGFloat(100), height: CGFloat(50)))
        button.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height*9/10)
        
        self.view.backgroundColor = backgroundColor
        self.view.addSubview(button)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testLoginFunction(){
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email", "user_friends"]
        let backgroundColor = UIColor.flatYellow()
        
        button.sizeThatFits(CGSize(width: CGFloat(100), height: CGFloat(50)))
        button.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height*9/10)
        
        self.view.backgroundColor = backgroundColor
        self.view.addSubview(button)
    }
    
}

<<<<<<< HEAD
extension ViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        delegate?.controller(self, didCompleteWithResult: result, error: error)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
=======
        }
    }
    
    func getLocationIDs(){
>>>>>>> 2a2f72247a57d29d0d141666a9d794e628cf09a9
        
       
        FBSDKGraphRequest(graphPath: "/search", parameters: ["pretty": "0", "type": "place", "center": "29.651634,-82.324829", "distance": "100", "limit": "25", "fields": "id"], httpMethod: "GET").start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                FBSDKGraphRequest(graphPath: "/events", parameters: ["ids": "141820976001317, 107173749306996, 1429754323987109"], httpMethod: "GET").start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        print(result as Any)
                    }
                })
                
            } else{
                print("error is \(error)")
            }
        })
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}


