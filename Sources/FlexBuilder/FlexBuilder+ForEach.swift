//
//  FlexBuilder+ForEach.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import Foundation
import UIKit
import RxSwift
import FlexLayout
public struct FForEach: ViewConvertable {
    private var views: [View] = []
    public init(_ count: Int, _ builder: (_ index: Int) -> View) {
        for index in 0..<count {
            views.append(builder(index))
        }
    }

    public init<Element>(_ array: [Element], _ builder: (_ element: Element) -> View) {
        views = array.map { builder($0) }
    }

    public func asViews() -> [View] {
        views
    }
}

public struct DynamicForEach: ModifiableView {
    public let modifiableView = BuilderDynamicForEach()
    
    public init() {
        
    }
    
    public init<Element>(_ array: Observable<[Element]>, _ builder:@escaping (_ index:Int,_ element: Element) -> View) {
        modifiableView.setData(array, builder)
    }
}

extension ModifiableView where Base == BuilderDynamicForEach {
    public func build() -> BuilderDynamicForEach {
        modifiableView
    }
    
    @discardableResult
    public func direction(_ value:Flex.Direction) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            view.flex.direction(value)
        }
    }
    
    public func itemsSource<Element>(_ array: Observable<[Element]>, _ builder:@escaping (_ index:Int,_ element: Element) -> View)  -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            view.setData(array, builder)
        }
    }
}

public class BuilderDynamicForEach: UIView {
    func setData<Element>(_ data:Observable<[Element]>, _ builder:@escaping (_ index:Int,_ element: Element) -> FlexBuilder.View) {
        data
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext:{[weak self] value in
                self?.updateData(value, builder)
            }).disposed(by: modifiableView.rxDisposeBag)
    }
    
    func updateData<Element>(_ data:[Element],_ builder: (_ index:Int, _ element: Element) -> FlexBuilder.View) {
        self.removeSubviews()
        for (index,item) in data.enumerated() {
            self.flex.addItem(builder(index,item).build())
        }
        self.flex.layout()
    }
}
