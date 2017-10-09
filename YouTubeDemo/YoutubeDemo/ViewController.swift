//
//  ViewController.swift
//  YoutubeDemo
//
//  Created by Rikka Vivekanand Reddy on 10/5/17.
//  Copyright © 2017 Rikka Vivekanand Reddy. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn
class ViewController: UIViewController {
    var btnSignIn = GIDSignInButton(frame: CGRect.zero)
    var btnCenterX: NSLayoutConstraint!
    var btnCenterY: NSLayoutConstraint!
    var btnWidth: NSLayoutConstraint!
    var btnHeight: NSLayoutConstraint!
   
    //MARK: View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialise Google Context
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil {
            print(error)
            return
        }
        setupButton()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: View setup methods
    func setupButton() {
        
      GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
       
//        view.addSubview(btnSignIn)
//        btnSignIn.translatesAutoresizingMaskIntoConstraints = false
//        btnCenterX = NSLayoutConstraint(item: btnSignIn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
//        btnCenterY = NSLayoutConstraint(item: btnSignIn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
//        btnWidth = NSLayoutConstraint(item: btnSignIn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
//        btnHeight = NSLayoutConstraint(item: btnSignIn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
//        view.addConstraints([btnHeight, btnWidth, btnCenterX, btnCenterY])
        
}
}

//MARK: Extensions
extension ViewController: GIDSignInDelegate, GIDSignInUIDelegate  {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            print("\(user.profile.email)")
            let username = "Name: " + user.profile.name
            let email = "\nEmail: " + user.profile.email
            let alertController = UIAlertController(title: "User Details", message:
                username + email, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
//            self.present(alertController, animated: true, completion: nil)
        let vc = YoutubeTableViewController()
        navigationController?.pushViewController(vc, animated: false)
    } else {
    print("\(error.localizedDescription)")
    }    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        
            // Perform any operations on signed in user here-navigate to next screen
           
    }
    

}

