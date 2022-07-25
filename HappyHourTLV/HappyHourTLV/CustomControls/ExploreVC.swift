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

        
        for index in 0...5 {
            let view = BarCellView()
            view.configure(image: UIImage(named: "happy-hour")!, title: "Index", descripation: String(index), identifier: String(index))
            view.delegate = self
            stackView.addArrangedSubview(view)
            
            
        }
    }
    
}

extension ExploreVC: BarCellViewDelegate {
    func viewDidPress(view: BarCellView, identifier: String) {
        print(identifier)
    }
}
