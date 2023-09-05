//
//  FlexBuilder+Debug.swift
//  FlexBuilder
//
//  Created by Chu Thin on 05/09/2023.
//

import Foundation

public protocol DebugBorder {}

#if DEBUG
extension UIView {
    private static var debugAttributesKey = "DebugAttributesKey"
    public var isDebug: Bool {
        get {
            objc_getAssociatedObject( self, &UIView.debugAttributesKey ) as? Bool ?? false
        }

        set {
            objc_setAssociatedObject(self, &UIView.debugAttributesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func drawBorder() {
        if isDebug {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            let debugColor = randomColor()
            context.saveGState()
            context.setStrokeColor(debugColor.cgColor)
            context.setLineDash(phase: 0, lengths: [4.0, 2.0])
            context.stroke(bounds)
            context.restoreGState()
        }
    }

    func randomColor() -> UIColor {
        let colors: [UIColor] = [.red, .green, .blue, .brown, .gray, .yellow, .magenta, .orange, .purple, .cyan]
        let randomIndex = Int(arc4random()) % colors.count
        return colors[randomIndex]
    }

    func setDebug(_ value: Bool) {
        isDebug = value
        for subView in self.subviews {
            subView.setDebug(value)
        }
    }
}
#endif


extension ModifiableView where Base: DebugBorder {
    @discardableResult
    public func debug(_ value: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            #if DEBUG
            view.setDebug(value)
            #endif
        }
    }
}
