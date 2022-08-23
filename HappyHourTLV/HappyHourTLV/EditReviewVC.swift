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
    
    var reviews: [Review] = []
    var review: Review?
    var user: User?
    var bar: Bar?
    var bars: [Bar] = []
    var identifier: Int?
    var rate: Int = 0
    
    private var imageData: Data = Data()
    
    override func viewWillAppear(_ animated: Bool) {
        Model.instance.getBar(ById: review?.barId ?? "", completion: {
            bar in
            self.bar = bar
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setKeyboardBehavior()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            let url = URL(string: self.bar?.imageUrl ?? "")
            let d = try? Data(contentsOf: url!)

            if let imageData = d {
                self.imageData = imageData
            }
            
            self.image.image = UIImage(data: self.imageData)
        })
      
        textField.text = review?.text ?? ""

        confirmButton.configure(text: "Save review", identifier: "")
        confirmButton.delegate = self
        setPopUpButton(rate: rate)
    }
    
    func setPopUpButton(rate: Int){
        let optionClosure = {(action: UIAction) in
            print(action.title)
            self.rate = Int(action.title) ?? 0
        }
        
        var elements: [UIAction] = []
        
        for index in 1..<6 {
            let indexString: String = String(index)
            if rate == index {
                elements.append(UIAction(title: indexString, state: .on, handler: optionClosure))
            } else {
                elements.append(UIAction(title: indexString, state: .off, handler: optionClosure))
            }
        }
        
        rateButton.menu = UIMenu(children: elements)

        rateButton.showsMenuAsPrimaryAction = true
        rateButton.changesSelectionAsPrimaryAction = true
        
    }
    
    func setKeyboardBehavior() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
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
        
        if segue.identifier == "EditReviewToUserProfileSegue" {
            let vc = (segue.destination as! UserProfileVC)
            vc.reviews = reviews
            vc.user = user
            vc.bars = bars
        }
    }

}

extension EditReviewVC: buttonDelegate {
    func buttonDidPress(button: Button, identifier: String) {
        //save review
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: currentDateTime)
        
        let review: Review = Review(uid: review?.uid ?? "",
                                    userName: review?.userName ?? "",
                                    userId: review?.userId ?? "",
                                    date: dateString,
                                    rate: rate,
                                    text: textField.text ?? "",
                                    barId: review?.barId ?? "",
                                    barName: review?.barName ?? "",
                                    userImageUrl: user?.imageUrl ?? "",
                                    barImageUrl: bar?.imageUrl ?? "")
        
        Model.instance.update(review: review)
        Model.instance.update(user: user!)
        Model.instance.update(bar: bar!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
            self.performSegue(withIdentifier: "EditReviewToUserProfileSegue", sender: self)
        })
        
    }
    
}
