//
//  ViewController.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 27/06/2022.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: Button!
    @IBOutlet weak var signUpButton: Button!
    
    override func viewDidLoad() {
            super.viewDidLoad()

            setKeyboardBehavior()
            
            image.image = UIImage(named: "happy-hour")
            
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            emailTextField.backgroundColor = .clear
            emailTextField.keyboardType = .emailAddress
            emailTextField.layer.borderColor = UIColor.white.cgColor
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.cornerRadius = 10
            
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            passwordTextField.backgroundColor = .clear
            passwordTextField.keyboardType = .default
            passwordTextField.isSecureTextEntry = true
            passwordTextField.layer.borderColor = UIColor.white.cgColor
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.cornerRadius = 10
            
            initViewInfo()
        }

        func initViewInfo() {
            loginButton.delegate = self
            loginButton.configure(text: "Log In", identifier: "login")
            signUpButton.delegate = self
            signUpButton.configure(text: "Sign-Up", identifier: "signUp")
        }
        @IBAction func forgotPasswordPressed(_ sender: Any) {
            print("Forgot password")
        }
        
        func setKeyboardBehavior() {
            view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        @objc func keyboardWillShow(notification: NSNotification) {
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                // if keyboard size is not available for some reason, dont do anything
                return
            }
            // move the root view up by the distance of keyboard height
            self.view.frame.origin.y = -keyboardSize.height
        }

        @objc func keyboardWillHide(notification: NSNotification) {
            // move back the root view origin to zero
            self.view.frame.origin.y = 0
        }
    }

    extension RegisterVC: buttonDelegate {
        func buttonDidPress(button: Button, identifier: String) {
            switch identifier {
            case "login":
                print("login")
            case "signUp":
                print("signUp")
            default:
                return
            }
            
        }
    }
