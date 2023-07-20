//
//  FlexBuilder.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
import FlexLayout

public protocol ViewConvertable {
    func asViews() -> [FView]
}

extension Array: ViewConvertable where Element == FView {
    public func asViews() -> [FView] { self }
}

// Allows an array of an array of views to be used with ViewResultBuilder
extension Array where Element == ViewConvertable {
    public func asViews() -> [FView] { self.flatMap { $0.asViews() } }
}

public protocol FView: ViewConvertable {
    func build() -> UIView
    //func build(direction : Flex.Direction) -> UIView
    func callAsFunction() -> UIView
}

extension FView {
    public func asViews() -> [FView] {
        [build()]
    }
    public func callAsFunction() -> UIView {
        build()
    }
}

// Allows view builder modifications to be made to a given UIView type
public protocol ModifiableView: FView {
    associatedtype Base: UIView
    var modifiableView: Base { get }
}

// Standard "builder" modifiers for all view types
extension ModifiableView {
    public func asBaseView() -> Base {
        modifiableView
    }
    public func build() -> UIView {
        modifiableView
    }

    public func build(direction: FlexLayout.Flex.Direction) -> UIView {
        modifiableView
    }
    
    @discardableResult
    public func reference<V:UIView>(_ view: inout V?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view = $0 as? V }
    }
    @discardableResult
    public func with(_ modifier: (_ view: Base) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView, modifier: modifier)
    }
}

// Generic return type for building/chaining view modifiers
public struct ViewModifier<Base:UIView>: ModifiableView {
    public let modifiableView: Base
    public init(_ view: Base) {
        self.modifiableView = view
    }
    public init(_ view: FView) where Base == UIView {
        self.modifiableView = view()
    }
    public init(_ view: Base, modifier: (_ view: Base) -> Void) {
        self.modifiableView = view
        modifier(view)
    }
    public init<Value>(_ view: Base, keyPath: ReferenceWritableKeyPath<Base, Value>, value: Value) {
        self.modifiableView = view
        self.modifiableView[keyPath: keyPath] = value
    }
}

// ViewBuilder allows for user-defined custom view configurations
public protocol ViewBuilder: ModifiableView {
    var body: FView { get }
}

extension ViewBuilder {
    // adapt viewbuilder to enable basic modifications
    public var modifiableView: UIView {
        body()
    }
    // allow basic conversion to UIView
    public func build() -> UIView {
        body()
    }
}

extension UIView: ModifiableView {

    public var modifiableView: UIView {
        self
    }

    public func build() -> UIView {
        self
    }

    public func asViews() -> [UIView] {
        [self]
    }

}

@resultBuilder public struct ViewResultBuilder {
    public static func buildBlock() -> [FView] {
        []
    }
    public static func buildBlock(_ values: ViewConvertable...) -> [FView] {
        values.flatMap { $0.asViews() }
    }

    public static func buildIf(_ value: ViewConvertable?) -> ViewConvertable {
        value ?? []
    }

    public static func buildEither(first: ViewConvertable) -> ViewConvertable {
        first
    }
    public static func buildEither(second: ViewConvertable) -> ViewConvertable {
        second
    }
    public static func buildArray(_ components: [[FView]]) -> [FView] {
        components.flatMap { $0 }
    }
}
