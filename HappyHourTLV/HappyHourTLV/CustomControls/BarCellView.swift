//
//  BarCellView.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 27/06/2022.
//

import UIKit

protocol BarCellViewDelegate {
    func viewDidPress(view: BarCellView, identifier: Int)
}

class BarCellView: UIView {

    @IBOutlet weak var button: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    
    private var identifier: Int?
    var delegate: BarCellViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(image: UIImage, title: String, address: String, identifier: Int) {
        self.image.image = image
        self.title.text = title
        self.address.text = address
        self.identifier = identifier
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
        Bundle.main.loadNibNamed("BarCellView", owner: self, options: nil)
        self.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 12
        self.image.layer.cornerRadius = 12
        contentView.fixInView(self)
    }
    
    @IBAction func viewPressed(_ sender: Any) {
        delegate?.viewDidPress(view: self, identifier: identifier ?? 0)
    }
}

