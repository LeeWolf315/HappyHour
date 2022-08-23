//
//  UserProfileVC.swift
//  HappyHourTLV
//
//  Created by Amir Titelman on 10/08/2022.
//

import UIKit
import Kingfisher
import FirebaseAuth

class UserProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var updatePictureButton: Button!
    @IBOutlet weak var seeReviewsButton: Button!
    @IBOutlet weak var editDetailsButton: Button!
    
    let userId = FirebaseAuth.Auth.auth().currentUser?.uid
    var user: User?
    var bars: [Bar] = []
    var reviews: [Review] = []
    
    private var userImage: String = ""
    
    var selectedImage: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        Model.instance.getUser(byId: userId ?? "", completion: {
            user in
            self.user = user
            self.titleLabel.text = "Hello, " + (user?.firstName ?? "")
        })
        loadUserReviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = UIImage(named: "happy-hour")
        
        titleLabel.text = "Hello, " + (user?.firstName ?? "")
        let url = URL(string: user?.imageUrl ?? "")
        userPicture.kf.setImage(with: url)
        userPicture.layer.cornerRadius = userPicture.frame.height / 2
        
        updatePictureButton.configure(text: "Update picture", identifier: "UpdatePicture")
        updatePictureButton.delegate = self
        seeReviewsButton.configure(text: "See my reviews", identifier: "SeeMyReviews")
        seeReviewsButton.delegate = self
        editDetailsButton.configure(text: "Edit my details", identifier: "EditMyDetails")
        editDetailsButton.delegate = self
        
    }
    
    private func loadUserReviews() {
        Model.instance.getAllReviews(byUserId: user!.uid, completion: {
            reviews in
            self.reviews = reviews ?? []
        })
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "UserProfileToHomeScreenSegue", sender: self)
    }
    
    private func takePicture(src: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = src;
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(
            src) {
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        if let userImage = selectedImage {
            Model.instance.uploadImage(name: self.userId ?? "", image: userImage) {
                url in
                self.userPicture.image = self.selectedImage
                self.user?.imageUrl = url
                Model.instance.update(user: self.user!)
                
                self.dismiss(animated: true)
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.takePicture(src: .photoLibrary)
        })
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.takePicture(src: .camera)
        })
        alert.addAction(action2)
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "UserProfileToEditUserDetailsSegue" {
            let vc = (segue.destination as! SignUpVC)
            vc.editUserDetailsMode = true
            vc.user = user
            vc.bars = bars
            vc.reviews = reviews
        } else if segue.identifier == "UserProfileToHomeScreenSegue" {
            let vc = (segue.destination as! ExploreVC)
            vc.openByUserDetails = true
            vc.user = user
            vc.bars = bars
            vc.reviews = reviews
        } else if segue.identifier == "UserProfileToUserReviewsSegue" {
            let vc = (segue.destination as! UserReviewsVC)
            vc.reviews = reviews
            vc.user = user
            vc.bars = bars
        }
    }
    
}

extension UserProfileVC: buttonDelegate {
    func buttonDidPress(button: Button, identifier: String) {
        switch identifier {
        case "UpdatePicture":
            showAlert()
        case "SeeMyReviews":
            print("SeeMyReviews")
            performSegue(withIdentifier: "UserProfileToUserReviewsSegue", sender: self)
        case "EditMyDetails":
            print("EditMyDetails")
            performSegue(withIdentifier: "UserProfileToEditUserDetailsSegue", sender: self)
        default:
            print("default")
        }
    }
}
