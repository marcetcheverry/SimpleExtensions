//
//  RoundedInitialsImageView.swift
//  SimpleExtensions
//
//  Created by Marc Etcheverry on 6/6/18.
//  Copyright © 2018 Tap Light Software. All rights reserved.
//

import UIKit

struct RoundedInitialsImageViewState {
    let image: UIImage?
    let initials: String
}

@IBDesignable class RoundedInitialsImageView: UIImageView {
    private enum Constant {
        static let testInitials = "AB"
    }

    lazy var label: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        return label
    }()

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // This presents a placeholder AB label
        configure(with: RoundedInitialsImageViewState(image: nil,
                                                      initials: Constant.testInitials))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.masksToBounds = true
    }

    func configure(with viewState: RoundedInitialsImageViewState) {
        if let newImage = viewState.image {
            layer.isOpaque = true
            label.text = nil
            label.isHidden = true
            image = newImage
        }
        else {
            displayLabel(viewState.initials)
        }
    }

    private func displayLabel(_ initials: String) {
        image = nil
        // This is because the rounding of the label may expose the superview
        layer.isOpaque = false
        label.isHidden = false
        label.text = initials

        if label.superview == nil {
            addSubview(label)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": label]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": label]))
            setNeedsLayout()
        }
    }
}
