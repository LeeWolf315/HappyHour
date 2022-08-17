//
//  reviewCell.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 13/08/2022.
//

import UIKit

protocol reviewCellDelegate {
    func editDidPress(identifier: Int)
    func deleteDidPress(identifier: Int)
}

class reviewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var reviewDescription: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    private var identifier: Int = -1
    var delegate: reviewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        
        editButton.layer.cornerRadius = 6
        deleteButton.layer.cornerRadius = 6
    }
    
    func configure(title: String, date: String, rate: Int, description: String, image: String, identifier: Int) {
        self.reviewTitle.text = title
        self.dateLabel.text = "Date: \(date)"
        self.rateLabel.text = "Rate: \(rate)"
        self.reviewDescription.text = description
        self.image.image = UIImage(named: image)
        self.identifier = identifier
    }
    
    func setButtonsShow(show: Bool) {
        buttonsView.isHidden = show
    }

    @IBAction func editPressed(_ sender: Any) {
        delegate?.editDidPress(identifier: identifier)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        delegate?.deleteDidPress(identifier: identifier)
    }
}
