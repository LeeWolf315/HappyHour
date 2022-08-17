//
//  BarDetailsVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 12/08/2022.
//

import UIKit

class BarDetailsVC: UIViewController {

    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var barView: BarCellView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var allReviewsView: UIView!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var submitReviewButton: Button!
    @IBOutlet weak var rateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setKeyboardBehavior()
        
        submitReviewButton.configure(text: "Submit review", identifier: "submitReviewButton")
        submitReviewButton.delegate = self
     
        allReviewsView.layer.cornerRadius = 6
        rateButton.layer.cornerRadius = 6
        setPopUpButton()
        
        let view = DealsView()
        view.configure(hours: "16-20", sale: "50% drinks")
        stackView.addArrangedSubview(view)
    }
    
    func setPopUpButton(){
        let optionClosure = {(action: UIAction) in
            print(action.title)
        }
        
        rateButton.menu = UIMenu(children: [
            UIAction(title: "1", state: .off, handler: optionClosure),
            UIAction(title: "2", state: .off, handler: optionClosure),
            UIAction(title: "3", state: .off, handler: optionClosure),
            UIAction(title: "4", state: .off , handler: optionClosure),
            UIAction(title: "5", state: .off, handler: optionClosure),
        ])
        
        rateButton.showsMenuAsPrimaryAction = true
        rateButton.changesSelectionAsPrimaryAction = true
        
    }

    @IBAction func seeAllReviewsPressed(_ sender: Any) {
        
    }
    
    @IBAction func userButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
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

extension BarDetailsVC: buttonDelegate {
    func buttonDidPress(button: Button, identifier: String) {
        print("Submit review")
    }
}
