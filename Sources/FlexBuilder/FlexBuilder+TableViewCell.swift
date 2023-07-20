//
//  FlexBuilder+BaseTableViewCell.swift
// FlexBuilder
//
//  Created by Chu Thin on 16/07/2023.
//

import UIKit
open class BaseTableViewCell : UITableViewCell, CellDataContext {
    public var data: Identifier?
    public var indexPath: IndexPath?
    var cellWidth: CGFloat = 0
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        initView()
    }
    
    open func initView() {
        let body = body().build()
        for sv in body.subviews {
            contentView.addSubview(sv)
        }
        contentView.backgroundColor(body.backgroundColor ?? .clear)
    }
    
    
    open func body() -> FView {
        return FVStack()
    }
    
    open func setDataContext(indexPath: IndexPath, data: Identifier, numberOfItems: Int) {
        self.data = data
        self.indexPath = indexPath
    }
    
    @discardableResult open func layout() -> CGFloat {
        contentView.pin.width(cellWidth)
        self.contentView.flex.layout(mode: .adjustHeight)
        return self.contentView.frame.height
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        layout()
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        cellWidth = size.width
        let maxY = layout()
        return CGSize(width: contentView.frame.width, height: maxY)
    }
}

open class ActionTableViewCell<Action> : BaseTableViewCell {
   public var handle: ((Action) -> Void)?
}
