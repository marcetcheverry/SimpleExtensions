//
//  UIScrollView+CurrentPage.swift
//  UIKitExtensions
//
//  Created by Marc Etcheverry on 6/6/18.
//  Copyright © 2018 Tap Light Software. All rights reserved.
//

import UIKit

// These should be used on scrollViewDidEndDecelerating
extension UIScrollView {
    // You could use UInt here, but since UIKit and Foundation in Swift have standarized to use Int, we will use that.
    // You could  remove the optional Int and follow UIKit conventions and return 0 when the page doesn't make sense since it can not be calculated.
    var currentPage: Int? {
        get {
            guard bounds.size.width > 0 else {
                return nil
            }
            
            var page = Int((contentOffset.x / bounds.size.width).rounded())
            
            // Just in case this gets called when we are "bouncing back" from the left
            if page < 0 {
                page = 0
            }
            
            return page
        }
        
        set {
            setCurrentPage(newValue, animated: false)
        }
    }
    
    func setCurrentPage(_ page: Int?, animated: Bool) {
        let newPage = page ?? 0
        
        guard newPage >= 0 && newPage != currentPage else {
            return
        }
        
        setContentOffset(CGPoint(x: bounds.size.width * CGFloat(newPage), y: 0), animated: animated)
    }
}
