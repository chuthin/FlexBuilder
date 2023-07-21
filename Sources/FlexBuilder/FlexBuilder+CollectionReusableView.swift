//
//  FlexBuilder+CollectionReusableView.swift
//  BuilderUI
//
//  Created by Chu Thin on 16/07/2023.
//

import UIKit
open class ActionSupplementaryView<Action>: BaseSupplementaryView  {
    public var handle: ((Action) -> Void)?
}

open class BaseSupplementaryView: UICollectionReusableView, CellDataContext {
    public var data: Identifier?
    var contentView:UIView?
    var estimatedHeigh:Bool = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initView() {
        contentView = body().build()
        if let view = contentView {
            self.addSubview(view)
        }
    }
    
    open func setEstimatedHeight(_ value:Bool = true) {
        self.estimatedHeigh = value
    }
    
    open func isEstimatedHeight() -> Bool {
        return estimatedHeigh
    }
    
    open func setDataContext(indexPath: IndexPath, data: Identifier, numberOfItems: Int) {
        self.data = data
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.pin.all()
        if isEstimatedHeight() {
            contentView?.flex.layout(mode: .adjustHeight)
        } else {
            contentView?.flex.layout()
        }
        
    }
    
    open func body() -> FView {
        return FSpacer()
    }
}
