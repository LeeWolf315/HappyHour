//
//  ExploreVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 27/06/2022.
//

import UIKit

class ExploreVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()

            setKeyboardBehavior()
            
            for index in 0...5 {
                let view = BarCellView()
                view.configure(image: UIImage(named: "happy-hour")!, title: "Index", descripation: String(index), identifier: String(index))
                view.delegate = self
                stackView.addArrangedSubview(view)
            }
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

    extension ExploreVC: BarCellViewDelegate {
        func viewDidPress(view: BarCellView, identifier: String) {
            print(identifier)
        }
    }
