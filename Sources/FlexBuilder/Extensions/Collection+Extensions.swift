//
//  Collection.swift
//  FlexBuilder
//
//  Created by Chu Thin on 15/07/2023.
//

import Foundation
public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
