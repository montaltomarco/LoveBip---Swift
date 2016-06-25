//
//  ConnectToUserViewController.swift
//  LoveBip
//
//  Created by Marco Montalto on 16/06/16.
//  Copyright © 2016 Marco Montalto. All rights reserved.
//

import UIKit

class ConnectToUserViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
        self.registerButton.layer.cornerRadius = 20
        self.registerButton.clipsToBounds = true
        
        self.initializeFields()
    }
    
    func initializeFields() {
        self.emailTextField.text = "Email"
        
        registerButton.enabled = false
        registerButton.alpha = 0.5;
    }
    @IBAction func registerToUser(sender: AnyObject) {
        
        let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("LoveBipUserEmail") as? String
        
        if let _ = userEmail {
            // REGISTER FOR NOTIFICATIONS
            APILoginSignup.registerPair(userEmail!, emailPair: self.emailTextField.text!) { (error) in
                if let _ = error {
                    print("There was an error registering ")
                } else {
                    //self.performSegueWithIdentifier("login_to_home_segue", sender: self)
                }
            }
        }
    }
    
    @IBAction func skipStepButtonTapped(sender: AnyObject) {
        initializeFields();
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func emailChanged(sender: AnyObject) {
        if isValidEmail(self.emailTextField.text!) {
            registerButton.enabled = true
            registerButton.alpha = 1;
        } else {
            registerButton.enabled = false
            registerButton.alpha = 0.5;
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        emailTextField.text = textField.text!
        return true
        
    }
}
