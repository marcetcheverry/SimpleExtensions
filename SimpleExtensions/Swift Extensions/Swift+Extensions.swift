//
//  Swift+Extensions.swift
//  SimpleExtensions
//
//  Created by Marc Etcheverry on 6/8/18.
//  Copyright © 2018 Tap Light Software. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
