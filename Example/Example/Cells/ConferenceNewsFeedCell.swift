//
//  ConferenceNewsFeedCell.swift
//  Example
//
//  Created by Chu Thin on 20/07/2023.
//

import Foundation
import FlexBuilder
class ConferenceNewsFeedCell: BaseCollectionViewCell {
    var titleLabel: FText
    var dateLabel: FText
    var bodyLabel: FText
    var separatorView: FDivider
    
    override func initView() {
        titleLabel = FText()
        dateLabel = FText()
        bodyLabel = FText()
        separatorView = FDivider()
        super.initView()
    }
    
    var showsSeparator = true {
        didSet {
            separatorView.display(showsSeparator)
        }
    }

    override func body() -> FView {
        FVStack {
            titleLabel
                .font(.preferredFont(forTextStyle: .title2))
                .numberOfLines(0)
                .margin(.vertical, 8)
                .margin(.horizontal, 12)
            dateLabel
                .font(.preferredFont(forTextStyle: .caption2))
                .margin(.horizontal,12)
            bodyLabel
                .numberOfLines(0)
                .font(.preferredFont(forTextStyle: .body))
                .margin(.vertical, 8)
                .margin(.horizontal, 12)
            separatorView
        }
    }

}
