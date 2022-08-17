//
//  UserProfileVC.swift
//  HappyHourTLV
//
//  Created by Amir Titelman on 10/08/2022.
//

import UIKit

class UserProfileVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var updatePictureButton: Button!
    @IBOutlet weak var seeReviewsButton: Button!
    @IBOutlet weak var editDetailsButton: Button!
    
    private var userName: String = ""
    private var userImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.image = UIImage(named: "happy-hour")
        
        titleLabel.text = "Hello, " + userName
        
        updatePictureButton.configure(text: "Update picture", identifier: "UpdatePicture")
        updatePictureButton.delegate = self
        seeReviewsButton.configure(text: "See my reviews", identifier: "SeeMyReviews")
        seeReviewsButton.delegate = self
        editDetailsButton.configure(text: "Edit my details", identifier: "EditMyDetails")
        editDetailsButton.delegate = self
    }
    
}

extension UserProfileVC: buttonDelegate {
    func buttonDidPress(button: Button, identifier: String) {
        switch identifier {
        case "UpdatePicture":
            print("UpdatePicture")
        case "SeeMyReviews":
            print("SeeMyReviews")
        case "EditMyDetails":
            print("EditMyDetails")
        default:
            print("default")
        }
    }
    
}
