//
//  FlexBuilder+Dynamic.swift
//  FlexBuilder
//
//  Created by Chu Thin on 23/08/2023.
//

import Foundation
import RxSwift
import UIKit
public struct FDynamic: ModifiableView {
    public let modifiableView = BuilderDynamicView()

    public init() {

    }

    public init<Element>(_ data: Observable<Element>, _ builder:@escaping (_ element: Element) -> FView) {
        modifiableView.setData(data, builder)
    }
}


public class BuilderDynamicView: UIView {
    func setData<Element>(_ data:Observable<Element>, _ builder:@escaping (_ element: Element) -> FlexBuilder.FView) {
        data
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext:{[weak self] value in
                self?.updateData(value, builder)
            }).disposed(by: modifiableView.rxDisposeBag)
    }

    func updateData<Element>(_ data:Element,_ builder: ( _ element: Element) -> FlexBuilder.FView) {
        self.removeSubviews()
        self.flex.addItem(builder(data).build())
        self.flex.layout()
    }
}
