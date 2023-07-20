//
//  FlexBuilder+Extensions.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit

// Helpers for view conversion
extension UIView {

    public func addSubview(_ view: FView) {
        self.flex.addItem(view())
    }

    public func removeSubviews() {
        for subivew in subviews {
            subivew.removeFromSuperview()
        }
    }
}



extension UIView {

    // goes to top of view chain, then initiates full search of view tree
    public func find<K:RawRepresentable>(_ key: K) -> UIView? where K.RawValue == Int {
        rootview.firstSubview(where: { $0.tag == key.rawValue })
    }
    public func find<K:RawRepresentable>(_ key: K) -> UIView? where K.RawValue == String {
        rootview.firstSubview(where: { $0.accessibilityIdentifier == key.rawValue })
    }

    // searches down the tree looking for identifier
    public func find<K:RawRepresentable>(subview key: K) -> UIView? where K.RawValue == Int {
        firstSubview(where: { $0.tag == key.rawValue })
    }
    public func find<K:RawRepresentable>(subview key: K) -> UIView? where K.RawValue == String {
        firstSubview(where: { $0.accessibilityIdentifier == key.rawValue })
    }

    // searches up the tree looking for identifier in superview path
    public func find<K:RawRepresentable>(superview key: K) -> UIView? where K.RawValue == Int {
        firstSuperview(where: { $0.tag == key.rawValue })
    }
    public func find<K:RawRepresentable>(superview key: K) -> UIView? where K.RawValue == String {
        firstSuperview(where: { $0.accessibilityIdentifier == key.rawValue })
    }

}

extension UIView {

    @available(iOS 12, *)
    public func scrollIntoView() {
        guard let scrollview = firstSuperview(where: { $0 is UIScrollView }) as? UIScrollView else {
            return
        }
        let visible = convert(frame, to: scrollview)
        UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            scrollview.scrollRectToVisible(visible, animated: false)
        }.startAnimation()
    }

}

extension UIView {

    public func firstSubview<Subview:UIView>(ofType subviewType: Subview.Type) -> Subview? {
        return firstSubview(where: { type(of: $0) == subviewType.self }) as? Subview
    }

    public func firstSubview(where predicate: (_ view: UIView) -> Bool) -> UIView? {
        for child in subviews {
            if predicate(child) {
                return child
            } else if let found = child.firstSubview(where: predicate){
                return found
            }
        }
        return nil
    }

    public func firstSuperview<Subview>(ofType subviewType: Subview.Type) -> Subview? {
        return firstSuperview(where: { type(of: $0) == subviewType.self }) as? Subview
    }

    public func firstSuperview(where predicate: (_ view: UIView) -> Bool) -> UIView? {
        if let parent = superview {
            return predicate(parent) ? parent : parent.firstSuperview(where: predicate)
        }
        return nil
    }

    public var rootview: UIView {
        firstSuperview(where: { $0.superview == nil }) ?? self
    }

}

extension UIView {

    func addHighlightOverlay(animated: Bool = true, removeAfter delay: TimeInterval? = nil) {
        let overlay = UIView(frame: self.bounds)
        if #available(iOS 13, *) {
            overlay.backgroundColor = .label
        } else {
            overlay.backgroundColor = .black
        }
        overlay.alpha = animated ? 0.0 : 0.15
        overlay.tag = 999
        addSubview(overlay)
        if animated {
            UIView.animate(withDuration: 0.1) {
                overlay.alpha = 0.15
            }
        }
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if animated {
                    UIView.animate(withDuration: 0.1) {
                        overlay.alpha = 0.15
                    } completion: { _ in
                        overlay.removeFromSuperview()
                    }
                } else {
                    overlay.removeFromSuperview()
                }
            }
        }
    }

    func removeHighlightOverlay(animated: Bool = true) {
        if let overlay = find(subview: 999) {
            overlay.removeFromSuperview()
        }
    }
}

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

extension Int: RawRepresentable {
    public init?(rawValue: Int) {
        self = rawValue
    }
    public var rawValue: Int {
        self
    }
}

extension String: RawRepresentable {
    public init?(rawValue: String) {
        self = rawValue
    }
    public var rawValue: String {
        self
    }
}
