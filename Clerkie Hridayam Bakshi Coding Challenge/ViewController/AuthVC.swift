//
//  ViewController.swift
//  Clerkie Hridayam Bakshi Coding Challenge
//
//  Created by hridayam bakshi on 1/16/19.
//  Copyright © 2019 hridayam bakshi. All rights reserved.
//

import UIKit
import CoreData

class AuthVC: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    
    @IBAction func login(_ sender: Any) {Auth.login(email: email.text ?? "", password: password.text ?? "", cb: {
            (loginState) in
            var title = ""
            var message = ""
            
            switch loginState {
                case .loggedIn:
                    openApplication()
                case .incorrectPassword:
                    title = "Incorrect Credentials"
                    message = "Please Check Your Credentials and Retry"
                    loginFailAlert(title: title, message: message)
                case .notRegistered:
                    title = "User Not Registered"
                    message = "Please Create an Account"
                    loginFailAlert(title: title, message: message)
                default:
                    title = "Something Went Wrong"
                    message = "Please Retry Logging in"
                    loginFailAlert(title: title, message: message)
                    print("Default Case, Something Went Wrong")
            }
        })
    }
    
    func openApplication() {
        dismissKeyboard()
        deregisterFromKeyboardNotifications()
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        self.present(mainView, animated: true, completion: nil)
    }
    
    func loginFailAlert(title: String, message: String) {
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.registerUser(email: "hridayambakshi@gmail.com", password: "password")
        Auth.registerUser(email: "test@test.com", password: "test")
        self.email.delegate = self
        self.password.delegate = self
        self.scrollView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        registerForKeyboardNotifications()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            //print(aRect)
            //print(activeField.frame.origin)
            //print(aRect.contains(activeField.superview!.superview!.frame.origin))
            //print(aRect.contains(activeField.frame.origin))
            if (!aRect.contains(activeField.frame.origin)){
                print("here")
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
    }
}
