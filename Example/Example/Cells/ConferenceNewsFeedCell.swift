//
//  ConferenceNewsFeedCell.swift
//  Example
//
//  Created by Chu Thin on 20/07/2023.
//

import Foundation
import FlexBuilder
class ConferenceNewsFeedCell: BaseCollectionViewCell {
    static let reuseIdentifier = "conference-news-feed-cell-reuseidentifier"
    let titleLabel = FText()
        .font(.preferredFont(forTextStyle: .title2))
        .numberOfLines(0)
        .userInteractionEnabled(false)
        .build()
    let dateLabel = FText()
        .font(.preferredFont(forTextStyle: .caption2))
        .userInteractionEnabled(false)
        .build()
    let bodyLabel = FText()
        .numberOfLines(0)
        .font(.preferredFont(forTextStyle: .body))
        .userInteractionEnabled(false)
        .build()
    let separatorView = FDivider().build()
    var showsSeparator = true {
        didSet {
            separatorView.display(showsSeparator ? .flex: .none)
        }
    }

    override func body() -> FView {
        FVStack {
            titleLabel
                .margin(.vertical, 8)
                .margin(.horizontal, 12)
            dateLabel
                .margin(.horizontal,12)
            bodyLabel
                .margin(.vertical, 8)
                .margin(.horizontal, 12)
            separatorView
        }
    }


   /* override func setDataContext(indexPath: IndexPath, data: ItemModel, numberOfItems: Int) {
        super.setDataContext(indexPath: indexPath, data: data, numberOfItems: numberOfItems)
        if let newsItem = data as? NewsFeedItem {
            self.titleLabel.text = newsItem.title
            self.bodyLabel.text = newsItem.body
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            self.dateLabel.text = dateFormatter.string(from: newsItem.date)
            self.showsSeparator = indexPath.item != numberOfItems - 1
            self.layout()
        }
    }*/
}
