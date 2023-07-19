//
//  FlexBuilder+Spacer.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
public struct FSpacer: ModifiableView {

    public var modifiableView = UIView()

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
