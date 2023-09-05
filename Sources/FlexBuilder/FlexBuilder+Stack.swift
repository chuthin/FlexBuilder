//
//  FlexBuilder+Stack.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
import FlexLayout
public struct FVStack: ModifiableView {
    public let modifiableView = BuilderStackView().then {
        $0.flex.direction(.column)
    }

    public init() {}
    
    public init( space: CGFloat = 0, isReverse:Bool = false , @ViewResultBuilder _ builder: () -> ViewConvertable) {
        if space > 0 {
            let views = builder().asViews()
            let count = views.count
            for (index, item) in views.enumerated() {
                if index > 0 && index < count {
                    modifiableView.flex.addItem(FSpacer(space).modifiableView)
                }
                modifiableView.flex.addItem(item.build())
            }
        } else {
            builder().asViews().forEach { modifiableView.flex.addItem($0.build()) }
        }
        if !isReverse {
            modifiableView.flex.direction(.column)
        } else {
            modifiableView.flex.direction(.columnReverse)
        }
    }
}

public struct FHStack: ModifiableView {

    public let modifiableView = BuilderStackView().then{
        $0.flex.direction(.row)
    }

    public init() {}
    
    public init( space: CGFloat = 0, isReverse:Bool = false, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        if space > 0 {
            let views = builder().asViews()
            let count = views.count
            for (index, item) in views.enumerated() {
                if index > 0 && index < count {
                    modifiableView.flex.addItem(FSpacer(width: space).modifiableView)
                }
                modifiableView.flex.addItem(item.build())
            }
        } else {
            builder().asViews().forEach { modifiableView.flex.addItem($0.build()) }
        }
        
        if !isReverse {
            modifiableView.flex.direction(.row)
        } else {
            modifiableView.flex.direction(.rowReverse)
        }
    }
}

public class BuilderStackView : UIView, ViewBuilderBackground, DebugBorder {
    public var stretchLayers: [CALayer]?
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.strectchFrame()
    }

#if DEBUG
override open func draw(_ rect: CGRect) {
    super.draw(rect)
    drawBorder()
}
#endif
}
