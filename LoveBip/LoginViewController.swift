//
//  LoginViewController.swift
//  LoveBip
//
//  Created by Marco Montalto on 15/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import NVActivityIndicatorView

class LoginViewController: UIViewController, NVActivityIndicatorViewable {
    
    var logo: UIImageView!
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    @IBOutlet weak var logoFixed: UIImageView!
    @IBOutlet weak var logoTextFixed: UIImageView!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var loginButtonsView: UIView!
    @IBOutlet weak var normalLoginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLineLabel: UILabel!
    @IBOutlet weak var passwordLineLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerNowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setRoundCornersForLoginButtons()
    
        if(self.logoFixed.alpha != 0) {
            //Set every element transparent at the beginning
            self.logoFixed.alpha = 0
            self.setAlphaOfEveryElement(0);
            logo = UIImageView(image: UIImage(named: "app-logo"))
            var appLogoFrame = logo.frame
            appLogoFrame.size.width = 131
            appLogoFrame.size.height = 160
            appLogoFrame.origin.x = (screenWidth/2)-(appLogoFrame.size.width/2)
            appLogoFrame.origin.y = (screenHeight/2)-(appLogoFrame.size.height/2)
            logo.frame = appLogoFrame
            
            self.view.addSubview(logo)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(self.logoFixed.alpha == 0) {
            animateLogo();
        }else{
            self.logoFixed.alpha = 1
        }
    }
    
    func createImageLogo() {
        logo = UIImageView(image: UIImage(named: "app-logo"))
        var appLogoFrame = logo.frame
        appLogoFrame.size.width = 117
        appLogoFrame.size.height = 160
        appLogoFrame.origin.x = (screenWidth/2)-(appLogoFrame.size.width/2)
        appLogoFrame.origin.y = (screenHeight/2)-(appLogoFrame.size.height/2)
        logo.frame = appLogoFrame
        
        self.view.addSubview(logo)
    }
    
    func setRoundCornersForLoginButtons() {
        let pathFbButton = UIBezierPath(roundedRect:self.fbLoginButton.bounds, byRoundingCorners:[.TopLeft, .BottomLeft], cornerRadii: CGSizeMake(20, 20))
        let maskLayerFB = CAShapeLayer()
        maskLayerFB.path = pathFbButton.CGPath
        self.fbLoginButton.layer.mask = maskLayerFB
        
        let pathGoogleButton = UIBezierPath(roundedRect:self.googleLoginButton.bounds, byRoundingCorners:[.TopRight, .BottomRight], cornerRadii: CGSizeMake(20, 20))
        let maskLayerGoogle = CAShapeLayer()
        maskLayerGoogle.path = pathGoogleButton.CGPath
        self.googleLoginButton.layer.mask = maskLayerGoogle
        
        self.normalLoginButton.layer.cornerRadius = 20;
        self.normalLoginButton.clipsToBounds = true
    }
    
    func setAlphaOfEveryElement(value: CGFloat) {
        self.logoTextFixed.alpha = value
        self.loginButtonsView.alpha = value
        self.emailTextField.alpha = value
        self.passwordLineLabel.alpha = value
        self.emailLineLabel.alpha = value
        self.passwordTextField.alpha = value
        self.forgotPasswordButton.alpha = value
        self.registerNowButton.alpha = value
        self.normalLoginButton.alpha = value
    }
    
    func animateLogo() {
        UIView.animateWithDuration(1.5, delay: 0.5, options: [], animations: { () -> Void in
            
            let factor = CGFloat(2)
            var logoFrame = self.logo.frame
            let wdiff: CGFloat = (logoFrame.size.width-(logoFrame.size.width/factor))/2
            
            logoFrame.size.width /= factor
            logoFrame.size.height /= factor
            logoFrame.origin.x += wdiff
            logoFrame.origin.y = self.logoFixed.frame.origin.y
            
            self.logo.frame = logoFrame
            
        }) { (Bool) -> Void in
            
            self.logo.hidden = true
            self.logoFixed.alpha = 1
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                
                // Make every element visible
                self.setAlphaOfEveryElement(1)
                
                }, completion: { (Bool) -> Void in
                    
            })
        }
    }
    
    @IBAction func facebookButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.startActivityAnimating("Logging in")
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email"], fromViewController: self)
        { (result, error) -> Void in
            if (error == nil){
                let fbLoginResult : FBSDKLoginManagerLoginResult = result
                if(fbLoginResult.grantedPermissions.contains("email"))
                {
                    self.getFBUserDataAndLogin()
                }
            } else {
                let alertController = UIAlertController(title: NSLocalizedString("OOPS",comment:"oops"), message: NSLocalizedString("AUTHENTICATION_FAILURE",comment:"authentication failure"), preferredStyle: .Alert)
                
                let action = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
                    return
                }
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion:nil)
            }
        }
    }
     
     func getFBUserDataAndLogin() {
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil) {
                    var personalInfos = [String: String]()
                    personalInfos["FBId"] = (result.objectForKey("id") as? String)!
                    personalInfos["first_name"] = (result.objectForKey("first_name") as? String)!
                    personalInfos["last_name"] = (result.objectForKey("last_name") as? String)!
                    personalInfos["pic_url"] = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    personalInfos["email"] = (result.objectForKey("email") as? String)!
                    
                    NSUserDefaults.standardUserDefaults().setObject(personalInfos["email"], forKey: "LoveBipUserEmail")
                    
                    APILoginSignup.loginWithFacebook(personalInfos["email"]!, queryParameters: personalInfos, completion: { (error) in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.stopActivityAnimating()
                        
                        if let _ = error {
                            self.logOut()
                            let alertController = UIAlertController(title: NSLocalizedString("There was a problem while trying to login.",comment:"oops"), message: NSLocalizedString("Please, get a coffee and try again later <3",comment:"Please, get a coffee and try again later <3"), preferredStyle: .Alert)
                            
                            let action = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
                                return
                            }
                            alertController.addAction(action)
                            self.presentViewController(alertController, animated: true, completion:nil)
                            
                        } else {
                            self.performSegueWithIdentifier("home_to_connect_ble", sender: self)
                            let deviceToken = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipDeviceToken") as? String
                            if let deviceToken = deviceToken {
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                                APILoginSignup.registerForNotifications(personalInfos["email"]!, deviceToken: deviceToken) { (error) -> Void in
                                    print("User is registered for notifications")
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                }
                            }
                        }
                    })
                }
            })
        }
     }
    
    func logOut() {
        let fbManager: FBSDKLoginManager = FBSDKLoginManager()
        fbManager.logOut()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("LoveBipUserEmail")
    }
}

