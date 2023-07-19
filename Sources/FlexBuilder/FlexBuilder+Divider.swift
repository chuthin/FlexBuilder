//
//  FlexBuilder+Divider.swift
//  FlexBuilder
//
//  Created by Chu Thin on 13/07/2023.
//

import Foundation
import UIKit
import FlexLayout
public struct FDivider: ModifiableView {
    public let modifiableView = BuilderDividerView().then {
        if #available(iOS 13, *) {
            $0.backgroundColor = UIColor.secondaryLabel
        } else {
            $0.backgroundColor = UIColor.gray
        }
    }

    public init(_ direction: Flex.Direction = .column) {
        if direction == .row || direction == .rowReverse {
            modifiableView.flex.margin(12, 4).width(0.4)
        }
        else {
            modifiableView.flex.margin(4, 12).height(0.4).grow(1).shrink(1)
        }
    }
}

extension ModifiableView where Base: BuilderDividerView {
    @discardableResult
    public func color(_ color: UIColor?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.backgroundColor = color }
    }
}

public class BuilderDividerView: UIView {}
