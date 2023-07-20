//
//  ListController.swift
//  BuilderUI
//
//  Created by Chu Thin on 18/07/2023.
//
import UIKit
import FlexBuilder
import RxSwift
public class TitleHeaderCell : BaseTableViewCell {
    @Variable var title: String = ""
    var disposeBag = DisposeBag()
    public override func body() -> FView {
        return FVStack {
            FText($title).numberOfLines(0).margin(.vertical,12).alignment(.center)
        }.backgroundColor(.gray)
    }

    public override func setDataContext(indexPath: IndexPath, data: Identifier, numberOfItems: Int) {
        if let value = data as? String {
            title = value
        }
        super.setDataContext(indexPath: indexPath, data: data,numberOfItems: numberOfItems)
    }
}
