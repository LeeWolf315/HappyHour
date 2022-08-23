//
//  ExploreVC.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 27/06/2022.
//

import UIKit
import FirebaseAuth
import CoreAudio

class ExploreVC: UIViewController {
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var selectedBar: Bar?
    var openByUserDetails: Bool = false
    
    var reviews: [Review] = []
    var bars: [Bar] = []
    private var image: Data = Data()
    var user: User?
    let userId = FirebaseAuth.Auth.auth().currentUser?.uid
    
    override func viewWillAppear(_ animated: Bool) {
        
        Model.instance.getUser(byId: userId ?? "", completion: {
            user in
            self.user = user
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<bars.count {
            let url = URL(string: bars[index].imageUrl)
            let d = try? Data(contentsOf: url!)
            
            if let imageData = d {
                image = imageData
            }
            
            let view = BarCellView()
            view.configure(image: UIImage(data: image) ?? UIImage(), title: bars[index].name, address: bars[index].address, identifier: index)
            view.delegate = self
            stackView.addArrangedSubview(view)
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        //Logout
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        performSegue(withIdentifier: "ExploreToRegisterSegue", sender: self)
    }
    
    
    @IBAction func userButtonPressed(_ sender: Any) {
        if openByUserDetails {
            openByUserDetails = false
            self.dismiss(animated: true)
        } else {
            performSegue(withIdentifier: "ExploreToUserProfileSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ExploreToBarDetailsSegue" {
            let vc = (segue.destination as! BarDetailsVC)
            vc.user = user
            vc.bar = selectedBar
            vc.reviews = reviews
        } else if segue.identifier == "ExploreToUserProfileSegue" {
            let vc = (segue.destination as! UserProfileVC)
            vc.user = user
            vc.bars = bars
            
        }
    }
}

extension ExploreVC: BarCellViewDelegate {
    func viewDidPress(view: BarCellView, identifier: Int) {
        print(identifier)
        selectedBar = bars[identifier]
        performSegue(withIdentifier: "ExploreToBarDetailsSegue", sender: self)
    }
}
