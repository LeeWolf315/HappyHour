//
//  SignUpVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 27/06/2022.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: Button!
    
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    private var isFirstNameValid = false
    private var isLastNameValid = false
    private var isEmailValid = false
    private var isPasswordValid = false
    
    var editUserDetailsMode: Bool = false
    
    var user: User?
    var bars: [Bar] = []
    var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardBehavior()
        
        image.image = UIImage(named: "happy-hour")
        datePicker.tintColor = .black
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 15
        datePicker.clipsToBounds = true
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        firstNameTextField.backgroundColor = .clear
        firstNameTextField.keyboardType = .default
        firstNameTextField.layer.borderColor = UIColor.white.cgColor
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.cornerRadius = 10
        firstNameTextField.tag = 0
        firstNameTextField.delegate = self
        firstNameErrorLabel.isHidden = true
        
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lastNameTextField.backgroundColor = .clear
        lastNameTextField.keyboardType = .default
        lastNameTextField.layer.borderColor = UIColor.white.cgColor
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.cornerRadius = 10
        lastNameTextField.tag = 1
        lastNameTextField.delegate = self
        lastNameErrorLabel.isHidden = true
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.backgroundColor = .clear
        emailTextField.keyboardType = .emailAddress
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.tag = 2
        emailTextField.delegate = self
        emailErrorLabel.isHidden = true
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.backgroundColor = .clear
        passwordTextField.keyboardType = .default
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.tag = 3
        passwordTextField.delegate = self
        passwordErrorLabel.isHidden = true
        
        confirmButton.configure(text: "Confirm", identifier: "confirm")
        confirmButton.delegate = self
        
        if editUserDetailsMode {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            let date = dateFormatter.date(from: user?.dateOfBirth ?? "")
            
            firstNameTextField.text = user?.firstName
            lastNameTextField.text = user?.lastName
            datePicker.date = date ?? Date()
            emailTextField.text = user?.email
            passwordTextField.text = user?.password
        }
    }
    
    func isValidName(text: String) -> Bool {
        if text.count < 2 {
            return false
        }
        let regEx = "^([a-zA-Z])*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return predicate.evaluate(with: text)
    }
    
    private func isValidateEmail(text: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z\\._%#$*+=-]+@([A-Za-z0-9-]{1,63}\\.)+[A-Za-z]{2,64}$"
        // "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: text)
    }
    
    private func isValidatePassword(text: String) -> Bool {
        if text.count < 6 {
            return false
        }
        let passwordRegEx = "^([A-Za-z]+[0-9]|[0-9]+[A-Za-z])[A-Za-z0-9]*$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        return passwordPredicate.evaluate(with: text)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SignUpToExploreSegue" {
            let vc = (segue.destination as! ExploreVC)
            vc.bars = self.bars
        }
    }
    
    private func validateFields() -> Bool {
        return isValidName(text: firstNameTextField.text ?? "") &&
        isValidName(text: lastNameTextField.text ?? "") &&
        isValidateEmail(text: emailTextField.text ?? "") &&
        isValidatePassword(text: passwordTextField.text ?? "")
    }
}

extension SignUpVC: buttonDelegate {
    func buttonDidPress(button: Button, identifier: String) {
        if !editUserDetailsMode {
            print("Confirm")
            if validateFields() {
                print("Move to home screen")
                FirebaseAuth.Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                    if let _eror = error {
                        print(_eror.localizedDescription )
                    }else{
                        let userID : String = (FirebaseAuth.Auth.auth().currentUser?.uid)!
                        
                        let dateOfbirth = self.datePicker.date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let dateString = dateFormatter.string(from: dateOfbirth)
                        
                        Model.instance.add(user: User(uid: userID,
                                                      firstName: self.firstNameTextField.text!,
                                                      lastName: self.lastNameTextField.text!,
                                                      email: self.emailTextField.text!,
                                                      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjly4qKE7rp1WGq1KUbV2Q-zWCm2rmlsEUd5KSAEN5Q2odS0secr2eSOmKmeAZjnkMlnY&usqp=CAU",
                                                      dateOfBirth: dateString,
                                                      password: self.passwordTextField.text!,
                                                      reviewsId: []))
                        
                        self.performSegue(withIdentifier: "SignUpToExploreSegue", sender: self)
                    }
                }
            }
            
        } else {
            let dateOfbirth = self.datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: dateOfbirth)
            
            if validateFields() {
                editUserDetailsMode = false
                user?.firstName = firstNameTextField.text!
                user?.lastName = lastNameTextField.text!
                user?.dateOfBirth = dateString
                user?.email = emailTextField.text!
                user?.password = passwordTextField.text!
                Model.instance.update(user: self.user!)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.dismiss(animated: true)
                })
                
            }
            
            for review in reviews {
                var fullName: String?
                var userImageUrl: String?
                if review.userId == user?.uid {
                    fullName = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
                    userImageUrl = user?.imageUrl
                }
                
                let r = Review(uid: review.uid,
                               userName: fullName ?? review.userName,
                               userId: user?.uid ?? "",
                               date: review.date,
                               rate: review.rate,
                               text: review.text,
                               barId: review.barId,
                               barName: review.barName,
                               userImageUrl: userImageUrl ?? review.userImageUrl,
                               barImageUrl: review.barImageUrl)
                Model.instance.update(review: r)
            }
        }
    }
}

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 { // FirstName
            if !isValidName(text: textField.text ?? "") {
                print("FirstName Not Valid")
                isFirstNameValid = false
                firstNameErrorLabel.isHidden = false
            } else {
                isFirstNameValid = true
                firstNameErrorLabel.isHidden = true
            }
            
        } else if textField.tag == 1 { // LastName
            if !isValidName(text: textField.text ?? "") {
                print("LastName Not Valid")
                isLastNameValid = false
                lastNameErrorLabel.isHidden = false
            } else {
                isLastNameValid = true
                lastNameErrorLabel.isHidden = true
            }
            
        } else if textField.tag == 2 { // Email
            if !isValidateEmail(text: textField.text ?? "") {
                print("Email Not Valid")
                isEmailValid = false
                emailErrorLabel.isHidden = false
            } else {
                isEmailValid = true
                emailErrorLabel.isHidden = true
            }
            
        } else if textField.tag == 3 { // Password
            if !isValidatePassword(text: textField.text ?? "") {
                print("Password Not Valid")
                isPasswordValid = false
                passwordErrorLabel.isHidden = false
            } else {
                isPasswordValid = true
                passwordErrorLabel.isHidden = true
            }
        }
        
    }
}
