//
// FlexBuilder+CollectionViewCell.swift
// FlexBuilder
//
//  Created by Chu Thin on 16/07/2023.
//

import UIKit

open class BaseCollectionViewCell : UICollectionViewCell, CellDataContext {
    public var data: Identifier?
    var estimatedHeigh:Bool = true
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.initView()
    }
    
    open func initView() {
        let body = body().build()
        for sv in body.subviews {
            contentView.addSubview(sv)
        }
        contentView.backgroundColor(body.backgroundColor ?? .clear)
    }
    
    open func isEstimatedHeight() -> Bool {
        return estimatedHeigh
    }
    
    open func setDataContext(indexPath: IndexPath, data: Identifier, numberOfItems: Int) {
        self.data = data
    }
    
    open func body() -> FView {
        return FVStack()
    }
    
    open func setEstimatedHeight(_ value:Bool = true) {
        self.estimatedHeigh = value
    }
    
    @discardableResult open func layout() -> CGFloat {
        if !isEstimatedHeight() {
            self.contentView.flex.layout()
        }
        else {
            self.contentView.flex.layout(mode: .adjustHeight)
        }
       
        return self.contentView.frame.height
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        layout()
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        let maxY = layout()
        return CGSize(width: contentView.frame.width, height: maxY)
    }
}

open class ActionCollectionViewCell<Action> : BaseCollectionViewCell {
    var handle: ((Action) -> Void)?
}
