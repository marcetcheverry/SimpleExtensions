//
//  UIScrollView+CurrentPage.swift
//  UIKitExtensions
//
//  Created by Marc Etcheverry on 6/6/18.
//  Copyright © 2018 Tap Light Software. All rights reserved.
//

import UIKit

/// Simple UILabel subclass that adds insets
@IBDesignable class InsetUILabel: UILabel {
    @IBInspectable var topInset: CGFloat = 8
    @IBInspectable var bottomInset: CGFloat = 8
    @IBInspectable var leftInset: CGFloat = 8
    @IBInspectable var rightInset: CGFloat = 8

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
