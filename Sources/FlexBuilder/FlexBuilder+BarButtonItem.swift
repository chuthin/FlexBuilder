//
//  FlexBuilder+BarButtonItem.swift
//  FlexBuilder
//
//  Created by Chu Thin on 17/07/2023.
//

import UIKit
import RxSwift
extension UIBarButtonItem {

    convenience public init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }

    convenience public init(image: UIImage?, style: UIBarButtonItem.Style) {
        self.init(image: image, style: style, target: nil, action: nil)
    }

    convenience public init(title: String?, style: UIBarButtonItem.Style) {
        self.init(title: title, style: style, target: nil, action: nil)
    }

    @discardableResult
    public func onTap(_ handler: @escaping (_ item: UIBarButtonItem) -> Void) -> Self {
        self.rx.tap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] () in handler(self) })
            .disposed(by: rxDisposeBag)
        return self
    }
}
