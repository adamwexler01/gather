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

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if (FBSDKAccessToken.current()) != nil {
            //User already has access to the api/connected to facebook
            //So we can just generate the account information from
            //the facebook api
            loginFBData()
            referenceFBData()
            
        } else {
            let button = FBSDKLoginButton()
            button.sizeThatFits(CGSize(width: CGFloat(100), height: CGFloat(50)))
            button.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height*9/10)
            self.view.addSubview(button)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func referenceFBData() {
        let request = FBSDKGraphRequest(graphPath:"me", parameters: ["fields":"email,first_name,gender"]);
        
        request?.start(completionHandler: { (connection, result, error) in
            if(error != nil){
                print("This is the result that you are looking for: \(String(describing: result))")
            } else {
                print("This is the seen error: \(String(describing: error))")
            }
        })
    }
    
    func loginFBData(){
        let faceBookLoginManger = FBSDKLoginManager()
        
        faceBookLoginManger.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if (error != nil)
            {
                print("error is \(error)")
            }
            if (result?.isCancelled)!
            {
                //handle cancelations
            }

        }
        
    }
}

