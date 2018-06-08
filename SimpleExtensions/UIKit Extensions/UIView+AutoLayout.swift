//
//  UIView+AutoLayout.swift
//  SimpleExtensions
//
//  Created by Marc Etcheverry on 6/8/18.
//  Copyright © 2018 Tap Light Software. All rights reserved.
//

import UIKit

extension UIView {
    func constrainToSuperviewCenter() {
        if let superview = self.superview {
            superview.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: superview,
                                   attribute: .centerX,
                                   multiplier: 1,
                                   constant: 0))
            superview.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: superview,
                                   attribute: .centerY,
                                   multiplier: 1,
                                   constant: 0))
        }
    }
    
    func constrainToSuperviewEdges() {
        if let superview = self.superview {
            superview.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: superview,
                                   attribute: .left,
                                   multiplier: 1,
                                   constant: 0))
            superview.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .right,
                                   relatedBy: .equal,
                                   toItem: superview,
                                   attribute: .right,
                                   multiplier: 1,
                                   constant: 0))
            superview.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: superview,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: 0))
            superview.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: superview,
                                   attribute: .top,
                                   multiplier: 1,
                                   constant: 0))
        }
    }
}
