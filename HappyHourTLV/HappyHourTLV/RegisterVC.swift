//
//  ViewController.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 27/06/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: Button!
    @IBOutlet weak var signUpButton: Button!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    private var isEmailValid = false
    private var isPasswordValid = false
    
    private var bars: [Bar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      initBars()
        
        setKeyboardBehavior()
        
        image.image = UIImage(named: "happy-hour")
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.backgroundColor = .clear
        emailTextField.keyboardType = .emailAddress
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.delegate = self
        emailTextField.tag = 0
        emailErrorLabel.isHidden = true
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.backgroundColor = .clear
        passwordTextField.keyboardType = .default
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        passwordErrorLabel.isHidden = true
        
        Model.instance.getAllBars() {
            bars in
            self.bars = bars
        }
        
        initViewInfo()
        
        
    }
    
    //    func initBars() {
    //        let bar1 = Bar(uid: UUID().uuidString,
    //                       name: "Imperial",
    //                       address: "HaYarkon St 66, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://www.secrettelaviv.com/wp-content/uploads/2015/11/36595_310363292419346_98911154_n.jpg",
    //                       fromHour: "17:00",
    //                       toHour: "20:00",
    //                       alcohol: 0.5,
    //                       food: 0)
    //        let bar2 = Bar(uid: UUID().uuidString,
    //                       name: "Beer Garden",
    //                       address: "Harav Reines St 2, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/06/66/60/06/beer-garden.jpg?w=1200&h=-1&s=1",
    //                       fromHour: "17:00",
    //                       toHour: "21:30",
    //                       alcohol: 0.5,
    //                       food: 0.5)
    //        let bar3 = Bar(uid: UUID().uuidString,
    //                       name: "Robina",
    //                       address: "Marmorek St 6, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://lh5.googleusercontent.com/p/AF1QipNJFpCGLvUdcuy9bxvJ8p3g0SYkY3FYNnqOuUr3=w500-h500-k-no",
    //                       fromHour: "18:00",
    //                       toHour: "21:00",
    //                       alcohol: 0.4,
    //                       food: 0.3)
    //        let bar4 = Bar(uid: UUID().uuidString,
    //                       name: "Shem tov",
    //                       address: "Sderot Masaryk 14, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://wherehappyhour.com/tlv/wp-content/uploads/sites/3/2018/11/where-happy-hour-tel-aviv48-1067x800.jpg",
    //                       fromHour: "18:00",
    //                       toHour: "21:30",
    //                       alcohol: 0.5,
    //                       food: 0.5)
    //        let bar5 = Bar(uid: UUID().uuidString,
    //                       name: "Simta",
    //                       address: "Dizengoff St 122, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://the-owners.com/wp-content/uploads/2020/03/56361730_2795665893991771_7306702753135329280_n.jpg",
    //                       fromHour: "17:00",
    //                       toHour: "21:00",
    //                       alcohol: 0.3,
    //                       food: 0.2)
    //        let bar6 = Bar(uid: UUID().uuidString,
    //                       name: "Fifty",
    //                       address: "King George St 50, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://media-cdn.tripadvisor.com/media/photo-s/1a/a3/e8/a6/caption.jpg",
    //                       fromHour: "18:00",
    //                       toHour: "22:30",
    //                       alcohol: 0.3,
    //                       food: 0.25)
    //        let bar7 = Bar(uid: UUID().uuidString,
    //                       name: "Bicicletta",
    //                       address: "Nahalat Binyamin St 29, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://biciclettatlv.co.il/wp-content/uploads/sites/14/2021/11/bicicletta_013-cae100761633684085577.jpg",
    //                       fromHour: "18:00",
    //                       toHour: "20:30",
    //                       alcohol: 0.5,
    //                       food: 0.5)
    //        let bar8 = Bar(uid: UUID().uuidString,
    //                       name: "Rova Wine Bar",
    //                       address: "Dizengoff St 192, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://rova-bar.co.il/wp-content/uploads/2020/02/cropped-RovaWineBar_logo-1-310x160.png",
    //                       fromHour: "18:00",
    //                       toHour: "21:00",
    //                       alcohol: 0.6,
    //                       food: 0.3)
    //        let bar9 = Bar(uid: UUID().uuidString,
    //                       name: "Dizzy Frishdon",
    //                       address: "Dizengoff St 121, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://www.secrettelaviv.com/wp-content/uploads/2016/02/Dizzy_Frishdon_1454783458.jpeg",
    //                       fromHour: "18:00",
    //                       toHour: "21:00",
    //                       alcohol: 0.5,
    //                       food: 0.4)
    //        let bar10 = Bar(uid: UUID().uuidString,
    //                       name: "Cerveza",
    //                       address: "Dizengoff St 174, Tel Aviv-Yafo",
    //                       reviewsId: [],
    //                       imageUrl: "https://media.easy.co.il/images/StaticLogo/9275710_1.jpg",
    //                       fromHour: "18:00",
    //                       toHour: "21:30",
    //                       alcohol: 0.5,
    //                       food: 0.5)
    //
    //        createBar(bar: bar1)
    //        createBar(bar: bar2)
    //        createBar(bar: bar3)
    //        createBar(bar: bar4)
    //        createBar(bar: bar5)
    //        createBar(bar: bar6)
    //        createBar(bar: bar7)
    //        createBar(bar: bar8)
    //        createBar(bar: bar9)
    //        createBar(bar: bar10)
    //
    //    }
    
    //    func createBar(bar: Bar) {
    //        let db = Firestore.firestore()
    //
    //        var ref: DocumentReference? = nil
    //        ref = db.collection("bars").addDocument(data: [
    //            "uid": bar.uid,
    //            "name": bar.name,
    //            "address": bar.address,
    //            "reviewsId": bar.reviewsId,
    //            "imageUrl": bar.imageUrl,
    //            "fromHour": bar.fromHour,
    //            "toHour": bar.toHour,
    //            "alcohol": bar.alcohol,
    //            "food": bar.food,
    //        ]) { err in
    //            if let err = err {
    //                print("Error adding document: \(err)")
    //            } else {
    //                print("Document added with ID: \(ref!.documentID)")
    //            }
    //        }
    //    }
    
    func initViewInfo() {
        loginButton.delegate = self
        loginButton.configure(text: "Log In", identifier: "login")
        signUpButton.delegate = self
        signUpButton.configure(text: "Sign-Up", identifier: "signUp")
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        print("Forgot password")
    }
    
    private func isEmailValid(text: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z\\._%#$*+=-]+@([A-Za-z0-9-]{1,63}\\.)+[A-Za-z]{2,64}$"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: text)
    }
    
    private func isPasswordValid(text: String) -> Bool {
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
        
        if segue.identifier == "RegisterToExploreSegue" {
            let vc = (segue.destination as! ExploreVC)
            vc.bars = self.bars
        } else if segue.identifier == "RegisterToSignUpSegue" {
            let vc = (segue.destination as! SignUpVC)
            vc.bars = self.bars
        }
    }
}

extension RegisterVC: buttonDelegate {
    func buttonDidPress(button: Button, identifier: String) {
        switch identifier {
        case "login":
            print("login")
            if isEmailValid, isPasswordValid {
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                    if let _eror = error{
                        let alert = UIAlertController(title: "Sign in failed", message: "Username or Password incorrect", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print(_eror.localizedDescription)
                    }else{
                        if let _res = result{
                            print(_res)
                            self.performSegue(withIdentifier: "RegisterToExploreSegue", sender: self)
                        }
                    }
                }
            }
        case "signUp":
            print("signUp")
            performSegue(withIdentifier: "RegisterToSignUpSegue", sender: self)
        default:
            return
        }
        
    }
}

extension RegisterVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 { // Email
            if !isEmailValid(text: textField.text ?? "") {
                print("Email Not Valid")
                isEmailValid = false
                emailErrorLabel.isHidden = false
            } else {
                isEmailValid = true
                emailErrorLabel.isHidden = true
            }
            
        } else if textField.tag == 1 { // Password
            if !isPasswordValid(text: textField.text ?? "") {
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
