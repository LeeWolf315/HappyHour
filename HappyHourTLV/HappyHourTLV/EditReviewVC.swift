//
//  EditReviewVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 15/08/2022.
//

import UIKit

class EditReviewVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setKeyboardBehavior()
        
        setPopUpButton()
    }
    
    func setPopUpButton(){
        let optionClosure = {(action: UIAction) in
            print(action.title)
        }
        
//        rateButton.menu = UIMenu(children: [
//            UIAction(title: "1", state: .off, handler: optionClosure),
//            UIAction(title: "2", state: .off, handler: optionClosure),
//            UIAction(title: "3", state: .off, handler: optionClosure),
//            UIAction(title: "4", state: .off , handler: optionClosure),
//            UIAction(title: "5", state: .off, handler: optionClosure),
//        ])
//
//        rateButton.showsMenuAsPrimaryAction = true
//        rateButton.changesSelectionAsPrimaryAction = true
        
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
