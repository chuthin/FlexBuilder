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
    var title:FText
    override func initView() {
        title = FText()
        super.initView()
    }
    
    override func body() -> FView {
        return FVStack {
            FVStack {
                title.color(.black).alignment(.center).alignSelf(.center)
            }.justifyContent(.center)
            .backgroundColor(.blue)
            .fits()
        }
    }
    
    override func setDataContext(indexPath: IndexPath, data: Identifier, numberOfItems: Int) {
        if let item = data as? Item {
            title.text("\(item.getVideo()?.rawValue ?? 0)")
        }
        super.setDataContext(indexPath: indexPath, data: data, numberOfItems: numberOfItems)
    }
    
    override func isEstimatedHeight() -> Bool {
        return false
    }
}
