//
//  FlexBuilder+Text.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
import RxSwift
public struct FText: ModifiableView {
    public let modifiableView = BuilderUILabel()
    public init(_ text: String? = nil) {
        modifiableView.text = text
    }

    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == String {
        self.text(bind: binding)
    }

    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == String? {
        self.text(bind: binding)
    }

    public init(_ text: Variable<String>) {
        self.text(bind: text)
    }

    public init(_ text: Variable<String?>) {
        self.text(bind: text)
    }
}

extension ModifiableView where Base: UILabel {

    @discardableResult
    public func color<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == UIColor {
        ViewModifier(modifiableView, binding: binding, keyPath: \.textColor)
    }

    @discardableResult
    public func color<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == UIColor? {
        ViewModifier(modifiableView, binding: binding, keyPath: \.textColor)
    }

    @discardableResult
    public func text<Binding:RxBinding>(bind binding: Binding, needsLayout:Bool = false) -> ViewModifier<Base> where Binding.T == String {
        ViewModifier(modifiableView) { modifiableView in
            binding.asObservable()
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext: { [weak modifiableView] value in
                    let lastValue = modifiableView?.text
                    modifiableView?.flexText(value)
                    if modifiableView?.numberOfLines == 0 && lastValue?.count ?? 0 != value.count && needsLayout {
                        modifiableView?.parentViewController?.builderContainerView?.flex.layout()
                    }
                })
                .disposed(by: modifiableView.rxDisposeBag)
        }
    }

    @discardableResult
    public func text<Binding:RxBinding>(bind binding: Binding, needsLayout:Bool = false) -> ViewModifier<Base> where Binding.T == String? {
        ViewModifier(modifiableView) { modifiableView in
            binding.asObservable()
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext: { [weak modifiableView] value in
                    let lastValue = modifiableView?.text
                    modifiableView?.flexText(value)
                    if modifiableView?.numberOfLines == 0 && lastValue?.count ?? 0 != value?.count ?? 0 && needsLayout {
                        modifiableView?.parentViewController?.builderContainerView?.flex.layout()
                    }
                })
                .disposed(by: modifiableView.rxDisposeBag)
        }
    }
}


extension ModifiableView where Base: UILabel {

    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.textAlignment, value: alignment)
    }

    @discardableResult
    public func color(_ color: UIColor?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.textColor, value: color)
    }

    @discardableResult
    public func font(_ font: UIFont?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.font, value: font)
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.font, value: .preferredFont(forTextStyle: style))
    }

    @discardableResult
    public func lineBreakMode(_ mode: NSLineBreakMode) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.lineBreakMode, value: mode)
    }

    @discardableResult
    public func numberOfLines(_ numberOfLines: Int) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.numberOfLines = numberOfLines
            $0.lineBreakMode = .byWordWrapping
        }
    }

    @discardableResult
    public func attributedText(_ value:NSAttributedString) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.attributedText, value: value)
    }

    @discardableResult
    public func text(_ value:String?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.flexText(value)
        }
    }

    @discardableResult
    public func attributedText(_ value:NSMutableAttributedString) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.attributedText, value: value)
    }

    public func build() -> UILabel {
        modifiableView
    }
}

extension ModifiableView where Base : BuilderUILabel {
    public func build() -> BuilderUILabel {
        modifiableView
    }

    @discardableResult
    public func color(_ gradient: FGradient) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.textGradient = gradient
        }
    }
}


public extension UILabel {
    func flexText(_ text:String?){
        self.text = text
        self.flex.markDirty()
    }
}

public class BuilderUILabel : UILabel, ViewBuilderBackground {
    public var stretchLayers: [CALayer]?
    public var textGradient: FGradient?
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.strectchFrame()
        if let graientValue = self.textGradient {
            let gradientImage = UIImage.gradientImage(bounds: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height + 4), gradient: graientValue)
            self.textColor = UIColor(patternImage: gradientImage)
        }
    }
}
