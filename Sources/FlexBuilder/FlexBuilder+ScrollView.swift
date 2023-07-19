//
//  FlexBuilder+ScrollView.swift
//  ViewBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
import FlexLayout
import RxSwift
public struct FScrollView: ModifiableView {
    public var modifiableView = BuilderInternalScrollView().then {
        $0.delegate = $0
    }

    public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        modifiableView.views = builder()
    }
}

public class BuilderInternalScrollView: UIScrollView, UIScrollViewDelegate {
    public var scrollViewDidScrollHandler: ((_ context: ViewBuilderContext<UIScrollView>) -> Void)?
    fileprivate var views: ViewConvertable? {
        didSet {
            if let views = views {

                for view in views.asViews() {
                    contentView?.flex.addItem(view.build())
                }
            }
        }
    }

    public init() {
        super.init(frame: UIScreen.main.bounds)
        contentView = UIView()
        if let view = contentView {
            self.addSubview(view)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var contentView: UIView?
    @objc public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollHandler?(ViewBuilderContext(view: self))
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.pin.all()
        self.contentView?.flex.layout(mode: .adjustHeight)
        self.contentSize = self.contentView?.frame.size ?? CGSize(width: 0, height: 0)

    }
}

extension ModifiableView where Base: BuilderInternalScrollView {
    @discardableResult
    @available(iOS 12, *)
    public func automaticallyAdjustForKeyboard() -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext: { [unowned modifiableView] notification in
                    modifiableView.contentInset = .zero
                    modifiableView.scrollIndicatorInsets = modifiableView.contentInset
                })
                .disposed(by: $0.rxDisposeBag)

            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil)
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext: { [unowned modifiableView] notification in
                    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

                    let keyboardScreenEndFrame = keyboardValue.cgRectValue
                    let keyboardViewEndFrame = modifiableView.convert(keyboardScreenEndFrame, from: modifiableView.window)
                    let bottom = keyboardViewEndFrame.height - modifiableView.safeAreaInsets.bottom
                    let oldInsets = modifiableView.contentInset

                    modifiableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
                    modifiableView.scrollIndicatorInsets = modifiableView.contentInset

                    if oldInsets.bottom == 0, let textfield = modifiableView.firstSubview(where: { $0 is UITextField && $0.isFirstResponder }) {
                        DispatchQueue.main.async {
                            textfield.scrollIntoView()
                        }
                    }
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }

    public func build() -> BuilderInternalScrollView {
        modifiableView
    }
}

extension ModifiableView where Base: UIScrollView {
    @discardableResult
    public func showVerticalIndicator(_ show: Bool) -> ViewModifier<Base> {
      ViewModifier(modifiableView, keyPath: \.showsVerticalScrollIndicator, value: show)
    }

    @discardableResult
    public func showHorizontalIndicator(_ show: Bool) -> ViewModifier<Base> {
      ViewModifier(modifiableView, keyPath: \.showsHorizontalScrollIndicator, value: show)
    }
    
    @discardableResult
    public func bounces(_ bounce: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.bounces, value: bounce)
    }
}
