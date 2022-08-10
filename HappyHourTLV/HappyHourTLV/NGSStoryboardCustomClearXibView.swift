//
//  NGSStoryboardCustomClearXibView.swift
//  HappyHourTLV
//
//  Created by Amir Titelman on 10/08/2022.
//

import Foundation
import UIKit

class NGSStoryboardCustomXibView: UIControl {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let customView = Bundle.main.loadNibNamed(xibName(), owner: self, options: nil)?.first as? UIView {
            backgroundColor = UIColor.clear
            //customView.backgroundColor = UIColor.clear
            addSubviewWithSameSizeConstraints(customView)
            awakeFromNib()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let customView = Bundle.main.loadNibNamed(xibName(), owner: self, options: nil)?.first as? UIView {
            backgroundColor = UIColor.clear
            //customView.backgroundColor = UIColor.clear
            addSubviewWithSameSizeConstraints(customView)
            self.sendSubviewToBack(customView)
        }
    }
    
    func xibName() -> String {
        return String(describing: type(of: self))
    }
    
}

class NGSStoryboardCustomClearXibView: NGSStoryboardCustomXibView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let customChild = subviews.first {
            customChild.backgroundColor = UIColor.clear
        }
    }
    
    required init(frame: CGRect) {
       
       super.init(frame: frame)
        if let customChild = subviews.first {
            customChild.backgroundColor = UIColor.clear
        }
    }
}


extension UIView {
    
    func addSameSizeConstraints(_ subview: UIView) {
        
        addSameSizeConstraints(subview, topView: nil)
    }
    
    func addSubviewWithSameSizeConstraints(_ subview: UIView) {
        /*
        by default, the autoresizing mask on a view gives rise to constraints that fully determine the view's position.
        Any constraints you set on the view are likely to conflict with autoresizing constraints,
        so you must turn off this property first. IB will turn it off for you.
        */
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subview);
        
        addSameSizeConstraints(subview)
    }
    
    fileprivate func addSameSizeConstraints(_ subview: UIView, topView: UIView?) {
        let padding: CGFloat = 0.0
        
        var topConstraint: NSLayoutConstraint!
        if topView == nil {
            // subview top is connected to view top
            topConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: padding)
        } else {
            // subview top is connected to bottom of topView
            topConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: topView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: padding)
        }
        
        let bottomConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: padding)
        
        let rightConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: padding)
        
        let leftConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: padding)
        
        addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
    }
}
