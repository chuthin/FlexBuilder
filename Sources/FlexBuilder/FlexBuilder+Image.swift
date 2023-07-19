//
//  FlexBuilder+Image.swift
//  FlexBuilder
//
//  CCreated by Chu Thin on 11/07/2023.
//

import UIKit
import RxSwift

public struct FImage: ModifiableView {

    public let modifiableView = UIImageView()

    public init(_ image: UIImage?) {
        modifiableView.image = image
    }

    public init(named name: String) {
        modifiableView.image = UIImage(named: name)
    }

    @available(iOS 13, *)
    public init(systemName name: String) {
        modifiableView.image = UIImage(systemName: name)
    }

    public init<Binding:RxBinding>(_ image: Binding) where Binding.T == UIImage {
        self.image(bind: image)
    }

    public init<Binding:RxBinding>(_ image: Binding) where Binding.T == UIImage? {
        self.image(bind: image)
    }
}

extension ModifiableView where Base: UIImageView {
    @discardableResult
    public func tintColor(_ color: UIColor?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.tintColor, value: color)
    }

}

extension ModifiableView where Base: UIImageView {

    @discardableResult
    public func image<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == UIImage {
        ViewModifier(modifiableView, binding: binding) { $0.image = $1 }
    }

    @discardableResult
    public func image<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == UIImage? {
        ViewModifier(modifiableView, binding: binding) { $0.image = $1 }
    }
    
    @discardableResult
    public func contentMode(_ value: UIView.ContentMode) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.contentMode(value)
        }
    }

}
