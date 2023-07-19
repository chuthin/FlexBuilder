//
//  FlexBuilder+View.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
import FlexLayout
import RxSwift
extension ModifiableView where Base : UIView {
    @discardableResult
    public func backgroundColor(_ value: UIColor) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.backgroundColor = value
        }
    }

    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.layer.cornerRadius = value
        }
    }
    
    @discardableResult
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            if #available(iOS 11, *) {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = radius
                var masked = CACornerMask()
                if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
                if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
                if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
                if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
                $0.layer.maskedCorners = masked
            }
            else {
                let path = UIBezierPath(roundedRect: $0.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                $0.layer.mask = mask
            }
        }
    }
    
    @discardableResult
    public func opacity(_ value: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.alpha = value
        }
    }

    @discardableResult
    public func isUserInteractionEnabled(_ value:Bool) -> ViewModifier<Base>
    {
        ViewModifier(modifiableView) {
            $0.isUserInteractionEnabled = value
        }
    }

    @discardableResult
    public func clipsToBounds(_ value:Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.clipsToBounds(value)
        }
    }
}

extension ModifiableView where Base: UIView{

    @discardableResult
    public func hidden<Binding:RxBinding>(bind binding: Binding, needsLayout : Bool = true) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView) { view in
            binding.asObservable()
                .observe(on: ConcurrentMainScheduler.instance)
                .subscribe(onNext: { [weak view] value in
                    view?.flex.display(value ? .none : .flex)
                    view?.isHidden = value
                    if needsLayout {
                        view?.parentViewController?.builderContainerView?.flex.layout()
                    }
                })
                .disposed(by: view.rxDisposeBag)
        }
    }

    @discardableResult
    public func userInteractionEnabled<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding, keyPath: \.isUserInteractionEnabled)
    }
    
    @discardableResult
    public func userInteractionEnabled(_ value:Bool) -> ViewModifier<Base>{
        ViewModifier(modifiableView) { view in
            view.isUserInteractionEnabled = value
        }
    }

    @discardableResult
    public func boder(_ color:UIColor,_ width:CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            view.layer.borderColor = color.cgColor
            view.layer.borderWidth = width
        }
    }
}

