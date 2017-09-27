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
        } else {
            let button = FBSDKLoginButton()
            button.sizeThatFits(CGSize(width: CGFloat(100), height: CGFloat(50)))
            button.center = self.view.center;
            self.view.addSubview(button)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

