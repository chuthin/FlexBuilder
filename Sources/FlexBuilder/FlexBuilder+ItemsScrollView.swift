//
//  FlexBuilder+ItemsScrollView.swift
// FlexBuilder
//
//  Created by Chu Thin on 16/07/2023.
//

import Foundation
import UIKit
import RxSwift
public protocol ItemsScrollView : UIScrollView {
    associatedtype Item
    var selectionHandler: SelectionHandler? {set get}
    var pagingHandler: ((Int) -> Void)? {set get}
    var cells:[any AnyCell] {set get}
    var items:[Item] {set get}
    func register(_ cellClass: AnyClass?, kind: String?, reuseIdentifier identifier: String)
    func setData(_ items:[Item])
}

extension ModifiableView where Base: ItemsScrollView {
    public func register( @AnyCellBuilder  _ builder: () -> [any AnyCell]) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.cells = builder()
            for cell in $0.cells {
                cell.register($0)
            }
        }
    }
    
    public func onSelect(_ handler: @escaping (_ context: CellContext) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.selectionHandler = handler
        }
    }
    
    public func onPageChange(_ handler: @escaping (_ context: Int) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.pagingHandler = handler
        }
    }
    
    public func pagingEnabled(_ value: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.isPagingEnabled = true
        }
    }
    
    @discardableResult
    public func verticalPage<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Int {
        ViewModifier(modifiableView) { view in
            binding.asObservable()
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext:{[weak view] value in
                    view?.scrollTo(verticalPage: value,animated: true)
                    view?.pagingHandler?(value)
                }).disposed(by: view.rxDisposeBag)
            
        }
    }
    
    @discardableResult
    public func horizontalPage<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Int {
        ViewModifier(modifiableView) { view in
            binding.asObservable()
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext:{[weak view] value in
                    view?.scrollTo(horizontalPage: value,animated: true)
                    view?.pagingHandler?(value)
                }).disposed(by: view.rxDisposeBag)
            
        }
    }
}

public protocol BaseItemsScrollView : ItemsScrollView where Item == Identifier {}

extension ModifiableView where Base: BaseItemsScrollView {
    public func itemsSource(_ observable: Variable<[Identifier]>) -> ViewModifier<Base> {
        return itemsSource(observable.asObservable())
    }

    public func itemsSource<Item:Identifier>(_ observable: Variable<[Item]>) -> ViewModifier<Base> {
        return itemsSource(observable.asObservable())
    }

    public func itemsSource(_ observable: Observable<[Identifier]>) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { modifiableView in
            observable
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext:{[weak modifiableView] value in
                    modifiableView?.setData(value)
                }).disposed(by: modifiableView.rxDisposeBag)
        }
    }

    public func itemsSource<Item: Identifier>(_ observable: Observable<[Item]>) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { modifiableView in
            observable
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext:{[weak modifiableView] value in
                    modifiableView?.setData(value)
                }).disposed(by: modifiableView.rxDisposeBag)
        }
    }
    
}
