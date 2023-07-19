//
//  ListController.swift
//  BuilderUI
//
//  Created by Chu Thin on 18/07/2023.
//
import UIKit
import FlexBuilder
public class TitleHeaderCell : BaseTableViewCell {
    var title = FText().numberOfLines(0).alignment(.center).build()
    public override func body() -> View {
        return FVStack {
            title.margin(.vertical,12)
        }.backgroundColor(.gray).build()
    }

    public override func setDataContext(indexPath: IndexPath, data: Identifier, numberOfItems: Int) {
        if let value = data as? String {
            title.flexText(value)
        }
        super.setDataContext(indexPath: indexPath, data: data,numberOfItems: numberOfItems)
    }
}
