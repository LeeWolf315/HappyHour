//
//  DealsView.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 11/08/2022.
//

import UIKit

class DealsView: UIView {

    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var saleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(hours: String, sale: String) {
        self.hoursLabel.text = hours
        self.saleLabel.text = sale
    }

}
