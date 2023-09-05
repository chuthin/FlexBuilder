//
//  FlexBuilder+Button.swift
//  FlexBuilder
//
//  Created by Chu Thin on 12/07/2023.
//

import UIKit
import RxSwift
import RxCocoa

public struct FButton: ModifiableView {

    public let modifiableView = BuilderUIButton()

    // lifecycle
    public init(_ title: String? = nil) {
        modifiableView.setTitle(title, for: .normal)
    }

    public init(image: String) {
        modifiableView.setImage(UIImage(named: image), for: .normal)
    }

    public init(_ view: () -> FView) {
        modifiableView.removeSubviews()
        let view = view().build().position(value: .absolute).all(0).userInteractionEnabled(false)
        modifiableView.flex.addItem(view)
    }
    
    public init(_ title: String? = nil, action: @escaping (_ context: ViewBuilderContext<UIButton>) -> Void) {
        modifiableView.setTitle(title, for: .normal)
        onTap(action)
    }
}

extension ModifiableView where Base: UIButton {

    @discardableResult
    public func title(_ value: String) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            view.title(value)
        }
    }

    @discardableResult
    public func alignment(_ alignment: UIControl.ContentHorizontalAlignment) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.contentHorizontalAlignment, value: alignment)
    }

    @discardableResult
    public func backgroundColor(_ color: UIColor, for state: UIControl.State) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.setBackgroundImage(UIImage(color: color), for: state) }
    }

    @discardableResult
    public func color(_ color: UIColor, for state: UIControl.State = .normal) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.setTitleColor(color, for: state) }
    }

    @discardableResult
    public func font(_ font: UIFont?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.titleLabel?.font = font }
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.titleLabel?.font = .preferredFont(forTextStyle: style) }
    }

    @discardableResult
    public func onTap(_ handler: @escaping (_ context: ViewBuilderContext<UIButton>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { [unowned modifiableView] view in
            view.rx.tap
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { () in handler(ViewBuilderContext(view: modifiableView)) })
                .disposed(by: view.rxDisposeBag)
        }
    }
}

extension ModifiableView where Base : UIButton {
    public func build() -> UIButton {
        modifiableView
    }
}

public class BuilderUIButton : UIButton, ViewBuilderBackground, DebugBorder{


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



