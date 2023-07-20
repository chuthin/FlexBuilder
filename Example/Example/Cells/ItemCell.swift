//
//  ItemCell.swift
//  Example
//
//  Created by Chu Thin on 20/07/2023.
//

import Foundation
import FlexBuilder
import RxSwift
class ItemCell : BaseCollectionViewCell {
    let item:Observable<String>? = Observable<String>.just("")
    override func body() -> FView {
        FVStack {
            FVStack {
                FText().text(bind: item ?? .empty()).color(.black).alignment(.center).alignSelf(.center)
            }.justifyContent(.center)
            .backgroundColor(.blue)
            .fits()
        }
    }
    
    override func isEstimatedHeight() -> Bool {
        return false
    }
}
