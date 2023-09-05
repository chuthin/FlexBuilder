//
//  FlexBuilder+Spacer.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
public struct FSpacer: ModifiableView {

    public var modifiableView = BuilderSpacer()

    public init() {
        modifiableView.height(16)
    }

    public init(_ height: CGFloat = 16) {
        modifiableView.height(height)
    }

    public init(width: CGFloat = 8) {
        modifiableView.width(width)
    }
}


public class BuilderSpacer : UIView {
#if DEBUG
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBorder()
    }
#endif
}
