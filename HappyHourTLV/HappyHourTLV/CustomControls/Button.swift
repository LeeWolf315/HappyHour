//
//  Button.swift
//  HappyHourTLV
//
//  Created by Lee Wolf on 27/06/2022.
//

import UIKit

protocol buttonDelegate {
    func buttonDidPress(button: Button, identifier: String)
}

class Button: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    private var identifier: String?
    
    var delegate: buttonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
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
        Bundle.main.loadNibNamed("Button", owner: self, options: nil)
        contentView.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = .clear
        contentView.fixInView(self)
    }
    
    func configure(text: String, identifier: String) {
        self.label.textColor = .white
        self.label.text = text
        self.identifier = identifier
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.buttonDidPress(button: self, identifier: identifier ?? "")
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

