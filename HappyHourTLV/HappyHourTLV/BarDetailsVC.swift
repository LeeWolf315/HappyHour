//
//  BarDetailsVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 12/08/2022.
//

import UIKit

class BarDetailsVC: UIViewController {
    
    @IBOutlet weak var barView: BarCellView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var allReviewsView: UIView!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var submitReviewButton: Button!
    @IBOutlet weak var rateButton: UIButton!
    
    var identifier: Int?
    private var rate: Int = 0
    private var image: Data = Data()
    
    var user: User?
    var bar: Bar?
    var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardBehavior()
        
        submitReviewButton.configure(text: "Submit review", identifier: "submitReviewButton")
        submitReviewButton.delegate = self
        
        allReviewsView.layer.cornerRadius = 6
        rateButton.layer.cornerRadius = 6
        setPopUpButton()
        
        let url = URL(string: bar?.imageUrl ?? "")
        let d = try? Data(contentsOf: url!)
        
        if let imageData = d {
            image = imageData
        }
        
        loadBarReviews()
        
        barView.configure(image: UIImage(data: image) ?? UIImage() , title: bar?.name ?? "", address: bar?.address ?? "",  identifier: 0)
        
        initStackView()
        
        initTextField()
    }
    
    private func loadBarReviews() {
        Model.instance.getAllReviews(ByBarId: bar!.uid, completion: {
            reviews in
            self.reviews = reviews ?? []
        })
    }
    
    private func initTextField() {
        reviewTextField.attributedPlaceholder = NSAttributedString(string: "Your review", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        reviewTextField.backgroundColor = .clear
        reviewTextField.keyboardType = .default
        reviewTextField.layer.cornerRadius = 10
        reviewTextField.delegate = self
    }
    
    private func initStackView() {
        if bar!.alcohol > 0 {
            let view1 = DealsView()
            view1.configure(hours: "\(bar?.fromHour ?? "")-\(bar?.toHour ?? "")", sale: "\(Int(bar!.alcohol*100))% on drinks menu")
            stackView.addArrangedSubview(view1)
        }
        
        if bar!.food > 0 {
            let view2 = DealsView()
            view2.configure(hours: "\(bar?.fromHour ?? "")-\(bar?.toHour ?? "")", sale: "\(Int(bar!.food*100))% on food menu")
            stackView.addArrangedSubview(view2)
        }
    }
    
    @IBAction func mapPressed(_ sender: Any) {
        performSegue(withIdentifier: "BarDetailsToMapSegue", sender: self)
    }
    
    
    func setPopUpButton(){
        let optionClosure = {(action: UIAction) in
            print(action.title)
            self.rate = Int(action.title) ?? 0
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "BarDetailsToBarReviewsSegue" {
            let vc = (segue.destination as! BarReviewsVC)
            vc.identifier = self.identifier
            vc.bar = self.bar
            vc.reviews = self.reviews
        } else if segue.identifier == "BarDetailsToMapSegue" {
            let vc = (segue.destination as! mapVC)
            vc.barName = self.bar?.name ?? ""
            vc.barAddress = self.bar?.address ?? ""
        }
    }
    
    @IBAction func seeAllReviewsPressed(_ sender: Any) {
        performSegue(withIdentifier: "BarDetailsToBarReviewsSegue", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
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
        //save review
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: currentDateTime)
        
        let review: Review = Review(uid: UUID().uuidString,
                                    userName: "\(user?.firstName ?? "") \(user?.lastName ?? "")",
                                    userId: user?.uid ?? "",
                                    date: dateString,
                                    rate: rate,
                                    text: reviewTextField.text ?? "",
                                    barId: bar?.uid ?? "",
                                    barName: bar?.name ?? "",
                                    userImageUrl: user?.imageUrl ?? "",
                                    barImageUrl: bar?.imageUrl ?? "")
        Model.instance.add(review: review)
        
        user?.reviewsId.append(review.uid)
        Model.instance.update(user: user!)
        
        bar?.reviewsId.append(review.uid)
        Model.instance.update(bar: bar!)
        
        self.dismiss(animated: true)
    }
}

extension BarDetailsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text ?? "")
    }
}

