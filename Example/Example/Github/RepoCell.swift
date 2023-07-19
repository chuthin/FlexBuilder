//
//  RepoCell.swift
//  BuilderUI
//
//  Created by Chu Thin on 19/07/2023.
//

import Foundation
import FlexBuilder
class RepoCell : ActionTableViewCell<GithubAction> {
    var title = FText()
        .numberOfLines(0)
        .margin(top: 12, bottom: 12, left: 24, right: 24).font(.title2)
        .build()
    var descriptonTitle = FText()
        .margin(top: 0, bottom: 12, left: 24, right: 24).font(.body).color(.darkGray)
        .numberOfLines(0).build()
    var divier = FDivider().build()
    override func body() -> UIView {
        FVStack {
            FHStack {
                FVStack {
                    title
                    descriptonTitle

                }.fits()
                FButton("More")
                    .backgroundColor(.lightGray)
                    .height(32)
                    .width(80)
                    .alignSelf(.center)
                    .margin(.right,12)
                    .onTap {[weak self] _ in
                        self?.handle?(.more(self?.data as? Repo))
                    }
            }
            divier
        }.build()
    }
}
