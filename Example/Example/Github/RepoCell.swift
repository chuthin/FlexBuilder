//
//  RepoCell.swift
//  BuilderUI
//
//  Created by Chu Thin on 19/07/2023.
//

import Foundation
import FlexBuilder
class RepoCell : ActionTableViewCell<GithubAction> {
    @Variable var repo: Repo? = nil
    @Variable var dividerHidden:Bool = true
    override func body() -> FView {
        FVStack {
            FHStack {
                FVStack {
                    FText($repo.asObservable().map{ $0?.name})
                        .numberOfLines(0)
                        .margin(top: 12, bottom: 12, left: 24, right: 24).font(.title2)
                    FText($repo.asObservable().map{ $0?.description})
                        .margin(top: 0, bottom: 12, left: 24, right: 24).font(.body).color(.darkGray)
                        .numberOfLines(0)
                   
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
            FDivider().hidden(bind: $dividerHidden)
        }
    }
}
