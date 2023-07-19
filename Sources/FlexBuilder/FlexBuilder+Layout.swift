//
//  FlexBuilder+Layout.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
import FlexLayout
extension ModifiableView {
    @discardableResult
    public func height(_ height: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.height(height)
        }
    }
    @discardableResult
    public func width(_ width: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            if width == .infinity {
                $0.flex.grow(1)
            }
            else {
                $0.flex.width(width)
            }
        }
    }

    @discardableResult
    public func margin(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.margin(top, left, bottom, right)
        }
    }

    @discardableResult
    public func margin(_ value: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.margin(value, value, value, value)
        }
    }

    @discardableResult
    public func margin(_ top: FPercent,_ left: FPercent,_ bottom: FPercent,_ right: FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.margin(top, left, bottom, right)
        }
    }

    @discardableResult
    public func padding(_ top: CGFloat,_ left: CGFloat,_ bottom: CGFloat,_ right: CGFloat) ->  ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.padding(top, left, bottom, right)
        }
    }

    @discardableResult
    public func padding(_ value: CGFloat) ->  ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.padding(value, value, value, value)
        }
    }

    @discardableResult
    public func margin(_ margin:Margin = .all,_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            switch margin {
            case .top:
                $0.flex.marginTop(value)
            case .bottom:
                $0.flex.marginBottom(value)
            case .vertical:
                $0.flex.marginVertical(value)
            case .horizontal:
                $0.flex.marginHorizontal(value)
            case .all:
                $0.flex.margin(value)
            case .left:
                $0.flex.marginLeft(value)
            case .right:
                $0.flex.marginRight(value)
            }
        }
    }
    @discardableResult
    public func margin(_ margin:Margin = .all,_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            switch margin {
            case .top:
                $0.flex.marginTop(value)
            case .bottom:
                $0.flex.marginBottom(value)
            case .vertical:
                $0.flex.marginVertical(value)
            case .horizontal:
                $0.flex.marginHorizontal(value)
            case .all:
                $0.flex.margin(value)
            case .left:
                $0.flex.marginLeft(value)
            case .right:
                $0.flex.marginRight(value)
            }
        }
    }

    @discardableResult
    public func padding(_ padding:Padding = .all,_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            switch padding {
            case .top:
                $0.flex.paddingTop(value)
            case .bottom:
                $0.flex.paddingBottom(value)
            case .vertical:
                $0.flex.paddingVertical(value)
            case .horizontal:
                $0.flex.paddingHorizontal(value)
            case .all:
                $0.flex.padding(value)
            case .left:
                $0.flex.paddingLeft(value)
            case .right:
                $0.flex.paddingRight(value)
            }
        }
    }
}

extension ModifiableView {
    @discardableResult
    public func wrap(_ value: Flex.Wrap) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.wrap(value)
        }
    }

    @discardableResult
    public func grow(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.grow(value)
        }
    }

    @discardableResult
    public func fits() -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.grow(1).shrink(1)
        }
    }

    @discardableResult
    public func shrink(_ value:CGFloat) -> ViewModifier<Base>{
        ViewModifier(modifiableView) {
            $0.flex.shrink(value)
        }
    }

    @discardableResult
    public func start(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.start(value)
        }
    }

    @discardableResult
    public func start(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.start(value)
        }
    }

    @discardableResult
    public func end(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.end(value)
        }
    }

    @discardableResult
    public func end(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.end(value)
        }
    }

    @discardableResult
    public func basis(_ value:CGFloat?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.basis(value)
        }
    }

    @discardableResult
    public func basis(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.basis(value)
        }
    }

    @discardableResult
    public func justifyContent(_ value:Flex.JustifyContent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.justifyContent(value)
        }
    }

    @discardableResult
    public func alignItems(_ value:Flex.AlignItems) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.alignItems(value)
        }
    }

    @discardableResult
    public func alignSelf(_ value:Flex.AlignSelf) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.alignSelf(value)
        }
    }

    @discardableResult
    public func alignContent(_ value:Flex.AlignContent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.alignContent(value)
        }
    }

    @discardableResult
    public func display(_ value:Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.display(value ? .flex : .none)
            $0.flex.markDirty()
            $0.isHidden = !value
        }
    }

    @discardableResult
    public func sizeThatFitsWrap(_ size:CGSize) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            _ = $0.flex.sizeThatFits(size: size)
        }
    }
    @discardableResult
    public func height(_ value:CGFloat?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.height(value)
        }
    }

    @discardableResult
    public func height(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.height(value)
        }
    }

    @discardableResult
    public func maxHeight(_ value:CGFloat?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.maxHeight(value)
        }
    }

    @discardableResult
    public func maxHeight(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.maxHeight(value)
        }
    }

    @discardableResult
    public func minHeight(_ value:CGFloat?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.minWidth(value)
        }
    }

    @discardableResult
    public func minHeight(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.minHeight(value)
        }
    }

    @discardableResult
    public func width(_ value:CGFloat?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.width(value)
        }
    }

    @discardableResult
    public func width(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.width(value)
        }
    }

    @discardableResult
    public func maxWidth(_ value:CGFloat?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.maxWidth(value)
        }
    }

    @discardableResult
    public func maxWidth(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.maxWidth(value)
        }
    }

    @discardableResult
    public func minWidth(_ value:CGFloat?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.minWidth(value)
        }
    }

    @discardableResult
    public func minWidth(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.minWidth(value)
        }
    }

    @discardableResult
    public func size(_ value:CGSize?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.size(value)
        }
    }

    @discardableResult
    public func size(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.size(value)
        }
    }

    @discardableResult
    public func aspectRatio(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.aspectRatio(value)
        }
    }

    @discardableResult
    public func aspectRatio(_ value: UIImageView) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.aspectRatio(of: value)
        }
    }

    @discardableResult
    public func top(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.top(value)
        }
    }

    @discardableResult
    public func top(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.top(value)
        }
    }

    @discardableResult
    public func bottom(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.bottom(value)
        }
    }

    @discardableResult
    public func bottom(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.bottom(value)
        }
    }

    @discardableResult
    public func left(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.left(value)
        }
    }

    @discardableResult
    public func left(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.left(value)
        }
    }

    @discardableResult
    public func right(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.right(value)
        }
    }

    @discardableResult
    public func right(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.right(value)
        }
    }

    @discardableResult
    public func all(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.all(value)
        }
    }

    @discardableResult
    public func all(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.all(value)
        }
    }

    @discardableResult
    public func vertically(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.vertically(value)
        }
    }

    @discardableResult
    public func vertically(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.vertically(value)
        }
    }

    @discardableResult
    public func horizontally(_ value:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.horizontally(value)
        }
    }

    @discardableResult
    public func horizontally(_ value:FPercent) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.horizontally(value)
        }
    }

    @discardableResult
    public func position(_ value: Flex.Position) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flex.position(value)
        }
    }
   

    @discardableResult
    public func intrinsicSize() -> CGSize {
        return self.modifiableView.flex.intrinsicSize
    }

    public func markDirty() {
        self.modifiableView.flex.markDirty()
    }
}

public enum Margin {
    case top
    case bottom
    case vertical
    case horizontal
    case left
    case right
    case all
}

public enum Padding {
    case top
    case bottom
    case vertical
    case horizontal
    case all
    case left
    case right
}

extension UIView {
    @discardableResult
    public func margin(_ margin:Margin = .all,_ value:CGFloat) -> Self {
        switch margin {
        case .top:
            self.flex.marginTop(value)
        case .bottom:

            self.flex.marginBottom(value)
        case .vertical:
            self.flex.marginVertical(value)
        case .horizontal:
            self.flex.marginHorizontal(value)
        case .all:
            self.flex.margin(value)
        case .left:
            self.flex.marginLeft(value)
        case .right:

            self.flex.marginRight(value)
        }
        return self
    }
    @discardableResult
    public func marginPercent(_ margin:Margin = .all,_ value:FPercent) -> Self {
        switch margin {
        case .top:
            self.flex.marginTop(value)
        case .bottom:
            self.flex.marginBottom(value)
        case .vertical:
            self.flex.marginVertical(value)
        case .horizontal:
            self.flex.marginHorizontal(value)
        case .all:
            self.flex.margin(value)
        case .left:
            self.flex.marginLeft(value)
        case .right:

            self.flex.marginRight(value)
        }
        return self
    }

    @discardableResult
    public func padding(_ margin:Padding = .all,_ value:CGFloat) -> Self {
        switch margin {
        case .top:
            self.flex.paddingTop(value)
        case .bottom:
            self.flex.paddingBottom(value)
        case .vertical:
            self.flex.paddingVertical(value)
        case .horizontal:
            self.flex.paddingHorizontal(value)

        case .all:
            self.flex.padding(value)
        case .left:
            self.flex.paddingLeft(value)
        case .right:
            self.flex.paddingRight(value)
        }
        return self
    }

    @discardableResult
    public func margin(_ top: FPercent,_ left: FPercent,_ bottom: FPercent,_ right: FPercent) -> Self {
        self.flex.margin(top, left, bottom, right)
        return self
    }

    @discardableResult
    public func margin(_ top: CGFloat,_ left: CGFloat,_ bottom: CGFloat,_ right: CGFloat) -> Self {
        self.flex.margin(top, left, bottom, right)
        return self
    }

    @discardableResult
    public func padding(_ top: CGFloat,_ left: CGFloat,_ bottom: CGFloat,_ right: CGFloat) -> Self {
        self.flex.padding(top, left, bottom, right)
        return self
    }

    @discardableResult
    public func wrap(_ value: Flex.Wrap) -> Self {
        self.flex.wrap(value)
        return self
    }

    @discardableResult
    public func grow(_ value:CGFloat) -> Self {
        self.flex.grow(value)
        return self
    }

    @discardableResult
    public func shrink(_ value:CGFloat) -> Self{
        self.flex.shrink(value)
        return self
    }

    @discardableResult
    public func start(_ value:CGFloat) -> Self {
        self.flex.start(value)
        return self
    }

    @discardableResult
    public func start(_ value:FPercent) -> Self {
        self.flex.start(value)
        return self
    }

    @discardableResult
    public func end(_ value:CGFloat) -> Self {
        self.flex.end(value)
        return self
    }

    @discardableResult
    public func end(_ value:FPercent) -> Self {
        self.flex.end(value)
        return self
    }

    @discardableResult
    public func basis(_ value:CGFloat?) -> Self {
        self.flex.basis(value)
        return self
    }

    @discardableResult
    public func basis(_ value:FPercent) -> Self {
        self.flex.basis(value)
        return self
    }

    @discardableResult
    public func justifyContent(_ value:Flex.JustifyContent) -> Self {
        self.flex.justifyContent(value)
        return self
    }

    @discardableResult
    public func alignItems(_ value:Flex.AlignItems) -> Self {
        self.flex.alignItems(value)
        return self
    }

    @discardableResult
    public func alignSelf(_ value:Flex.AlignSelf) -> Self {
        self.flex.alignSelf(value)
        return self
    }

    @discardableResult
    public func alignContent(_ value:Flex.AlignContent) -> Self {
        self.flex.alignContent(value)
        return self
    }

    @discardableResult
    public func display(_ value:Bool) -> Self {
        self.flex.display(value ? .flex : .none)
        self.flex.markDirty()

        self.isHidden = !value
        return self
    }

    @discardableResult
    public func sizeThatFitsWrap(_ size:CGSize) -> Self {
        _ = self.flex.sizeThatFits(size: size)
        return self
    }
    @discardableResult
    public func height(_ value:CGFloat?) -> Self {
        self.flex.height(value)
        return self
    }

    @discardableResult
    public func height(_ value:FPercent) -> Self {
        self.flex.height(value)
        return self
    }

    @discardableResult
    public func maxHeight(_ value:CGFloat?) -> Self {
        self.flex.maxHeight(value)
        return self
    }

    @discardableResult
    public func maxHeight(_ value:FPercent) -> Self {
        self.flex.maxHeight(value)
        return self
    }

    @discardableResult
    public func minHeight(_ value:CGFloat?) -> Self {
        self.flex.minHeight(value)
        return self
    }

    @discardableResult
    public func minHeight(_ value:FPercent) -> Self {
        self.flex.minHeight(value)
        return self
    }

    @discardableResult
    public func width(_ value:CGFloat?) -> Self {
        self.flex.width(value)
        return self
    }

    @discardableResult
    public func width(_ value:FPercent) -> Self {
        self.flex.width(value)
        return self
    }

    @discardableResult
    public func maxWidth(_ value:CGFloat?) -> Self {
        self.flex.maxWidth(value)
        return self
    }

    @discardableResult
    public func maxWidth(_ value:FPercent) -> Self {
        self.flex.maxWidth(value)
        return self
    }

    @discardableResult
    public func minWidth(_ value:CGFloat?) -> Self {
        self.flex.minWidth(value)
        return self
    }

    @discardableResult
    public func minWidth(_ value:FPercent) -> Self {
        self.flex.minWidth(value)
        return self
    }

    @discardableResult
    public func size(_ value:CGSize?) -> Self {
        self.flex.size(value)
        return self
    }

    @discardableResult
    public func size(_ value:CGFloat) -> Self {
        self.flex.size(value)
        return self
    }

    @discardableResult
    public func aspectRatio(_ value:CGFloat) -> Self {
        self.flex.aspectRatio(value)
        return self
    }

    @discardableResult
    public func aspectRatio(_ value: UIImageView) -> Self {
        self.flex.aspectRatio(of: value)
        return self
    }

    @discardableResult
    public func top(_ value:CGFloat) -> Self {
        self.flex.top(value)
        return self
    }

    @discardableResult
    public func top(_ value:FPercent) -> Self {
        self.flex.top(value)
        return self
    }

    @discardableResult
    public func bottom(_ value:CGFloat) -> Self {
        self.flex.bottom(value)
        return self
    }

    @discardableResult
    public func bottom(_ value:FPercent) -> Self {
        self.flex.bottom(value)
        return self
    }

    @discardableResult
    public func left(_ value:CGFloat) -> Self {
        self.flex.left(value)
        return self
    }

    @discardableResult
    public func left(_ value:FPercent) -> Self {
        self.flex.left(value)
        return self
    }

    @discardableResult
    public func right(_ value:CGFloat) -> Self {
        self.flex.right(value)
        return self
    }

    @discardableResult
    public func right(_ value:FPercent) -> Self {
        self.flex.right(value)
        return self
    }

    @discardableResult
    public func all(_ value:CGFloat) -> Self {
        self.flex.all(value)
        return self
    }

    @discardableResult
    public func all(_ value:FPercent) -> Self {
        self.flex.all(value)
        return self
    }

    @discardableResult
    public func vertically(_ value:CGFloat) -> Self {
        self.flex.vertically(value)
        return self
    }

    @discardableResult
    public func vertically(_ value:FPercent) -> Self {
        self.flex.vertically(value)
        return self
    }

    @discardableResult
    public func horizontally(_ value:CGFloat) -> Self {
        self.flex.horizontally(value)
        return self
    }

    @discardableResult
    public func horizontally(_ value:FPercent) -> Self {
        self.flex.horizontally(value)
        return self
    }

    @discardableResult
    public func position(value: Flex.Position) -> Self {
        self.flex.position(value)
        return self
    }
    @discardableResult
    public func userInteractionEnabled(_ value:Bool) -> Self
    {
        self.isUserInteractionEnabled = value
        return self
    }

    @discardableResult
    public func intrinsicSize() -> CGSize {
        return self.flex.intrinsicSize
    }

    public func markDirty() {
        self.flex.markDirty()
    }
}
