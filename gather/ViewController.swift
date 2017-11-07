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
        
        let button = FBSDKLoginButton()
        button.delegate = self
        var logoView = UIImageView()
        
        if let image = UIImage(named:"logo_1"){
            //logoView.image = image
            //logoView.frame(forAlignmentRect: CGRect(x: UIScreen.main.bounds.midX/8, y: UIScreen.main.bounds.midY/8, width: 25.0, height: 25.0))
            logoView = UIImageView(image: image)
            logoView.frame = CGRect(x: UIScreen.main.bounds.midX/2, y: UIScreen.main.bounds.midY/3, width: 200.0, height: 200.0)
        }
        
        
        let backgroundColor = UIColor.init(gradientStyle: .leftToRight, withFrame: UIScreen.main.bounds, andColors: [UIColor.flatMint(), UIColor.flatMintColorDark()])
        
        button.sizeThatFits(CGSize(width: CGFloat(100), height: CGFloat(50)))
        button.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.size.height*9/10)
        
        self.view.backgroundColor = backgroundColor
        self.view.addSubview(button)
        
        view.addSubview(logoView)
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

extension ViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        delegate?.controller(self, didCompleteWithResult: result, error: error)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}

