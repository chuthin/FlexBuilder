//
//  FlexBuilder+Switch.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
import RxSwift

public struct FSwitch: ModifiableView {

    public let modifiableView: UISwitch = UISwitch()

    // lifecycle
    public init(_ isOn: Bool = true) {
        modifiableView.isOn = isOn
    }

    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == Bool {
        isOn(bind: binding)
    }

    public init<Binding:RxBidirectionalBinding>(_ binding: Binding) where Binding.T == Bool {
        isOn(bidirectionalBind: binding)
    }

}

extension ModifiableView where Base: UISwitch {
    @discardableResult
    public func isOn<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding, keyPath: \.isOn)
    }

    @discardableResult
    public func isOn<Binding:RxBidirectionalBinding>(bidirectionalBind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView) { switchView in
            let relay = binding.asRelay()
            switchView.rxDisposeBag.insert(
                relay
                    .observe(on: ConcurrentMainScheduler.instance)
                    .subscribe(onNext: { [weak switchView] value in
                        if let view = switchView, view.isOn != value {
                            view.isOn = value
                        }
                    }),
                switchView.rx.isOn
                    .observe(on: ConcurrentMainScheduler.instance)
                    .subscribe(onNext: { [weak relay] value in
                        if let relay = relay, relay.value != value {
                            relay.accept(value)
                        }
                    })
            )
        }
    }

    @discardableResult
    public func onTintColor(_ color: UIColor?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.onTintColor, value: color)
    }

    @discardableResult
    public func onChange(_ handler: @escaping (_ context: ViewBuilderValueContext<UISwitch, Bool>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.rx.isOn
                .changed
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext: { [unowned modifiableView] value in
                    handler(ViewBuilderValueContext(view: modifiableView, value: modifiableView.isOn))
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }
}
