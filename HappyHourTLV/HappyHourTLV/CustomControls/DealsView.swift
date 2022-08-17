//
//  DealsView.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 11/08/2022.
//

import UIKit

class DealsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var saleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(hours: String, sale: String) {
        self.hoursLabel.text = hours
        self.saleLabel.text = sale
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DealsView", owner: self, options: nil)
        self.backgroundColor = .clear
        contentView.fixInView(self)
    }

}
