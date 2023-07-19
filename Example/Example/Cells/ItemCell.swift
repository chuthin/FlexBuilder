//
//  ItemCell.swift
//  Example
//
//  Created by Chu Thin on 20/07/2023.
//

import Foundation
import FlexBuilder
class ItemCell : BaseCollectionViewCell {
    let title = FText().color(.black).build()
    override func body() -> UIView {
        FVStack {
            FVStack {
                title.alignment(.center).alignSelf(.center)
            }.justifyContent(.center)
                .backgroundColor(.blue)
                .fits()
           
        }.build()
    }
    
    override func isEstimatedHeight() -> Bool {
        return false
    }
}
