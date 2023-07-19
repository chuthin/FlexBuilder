//
//  ListController.swift
//  BuilderUI
//
//  Created by Chu Thin on 18/07/2023.
//

import Foundation
import FlexBuilder
public class TitleCell : BaseTableViewCell {
    var title = FText().numberOfLines(0).font(.title1).build()
    var descriptonTitle = FText().numberOfLines(0).font(.body).color(.darkGray).build()
    var divier = FDivider().build()
    public override func body() -> UIView {
        FVStack {
            title.margin(top: 12, bottom: 12, left: 24, right: 24)
            descriptonTitle.margin(top: 0, bottom: 12, left: 24, right: 24)
            divier
        }.build()
    }
}

