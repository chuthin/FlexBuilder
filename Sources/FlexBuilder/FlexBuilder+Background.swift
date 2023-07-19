//
//  FlexBuilder+Gradient.swift
//  BuilderUI
//
//  Created by Chu Thin on 17/07/2023.
//

import UIKit

public struct FGradient {
    public var colors:[UIColor]
    public var startPoint:CGPoint
    public var endPoint:CGPoint
    public var locations: [NSNumber]
    public var type: CAGradientLayerType
    public init( _ colors:[UIColor], startPoint:CGPoint = CGPoint(x: 0, y: 0), endPoint:CGPoint = CGPoint(x: 1, y: 0), locations:[NSNumber] = [0.0 , 1.0], type: CAGradientLayerType = .axial) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.locations = locations
        self.type = type
    }
}

public protocol ViewBuilderBackground : UIView {
    var stretchLayers: [CALayer]? {set get}
    func background(_ gradient: FGradient)
    func background(_ image:UIImage?, contentsGravity:CALayerContentsGravity)
}


extension ViewBuilderBackground  {
    public func background(_ gradient: FGradient) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradient.colors.map{ $0.cgColor}
        gradientLayer.type = gradient.type
        gradientLayer.locations = gradient.locations
        gradientLayer.startPoint = gradient.startPoint
        gradientLayer.endPoint = gradient.endPoint
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
        if(stretchLayers == nil){
            stretchLayers = []
        }
        self.stretchLayers?.append(gradientLayer)
        if let button = self as? UIButton,let image = button.imageView {
            button.bringSubviewToFront(image)
        }
    }

    public func background(_ image:UIImage?, contentsGravity:CALayerContentsGravity) {
        if let image = image {
            let imageLayer = CALayer()
            imageLayer.contents = image.cgImage
            imageLayer.contentsGravity = contentsGravity
            if(stretchLayers == nil){
                stretchLayers = []
            }
            self.layer.insertSublayer(imageLayer, at: 0)
            self.stretchLayers?.append(imageLayer)
        }
    }

    public func strectchFrame() {
        if let layers = self.stretchLayers {
            for layer in layers {
                layer.frame = self.bounds
            }
        }
    }
}

extension ModifiableView where Base: ViewBuilderBackground {
    @discardableResult
    public func background(_ value: FGradient) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.background(value)
        }
    }

    @discardableResult
    public func background(_ image:UIImage?, contentsGravity:CALayerContentsGravity = .resizeAspectFill) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.background(image, contentsGravity: contentsGravity)
        }
    }
}


extension UIImage {
    public static func gradientImage(bounds: CGRect, gradient: FGradient) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradient.colors.map(\.cgColor)
        // This makes it left to right, default is top to bottom
        gradientLayer.startPoint = gradient.startPoint
        gradientLayer.endPoint = gradient.endPoint
        gradientLayer.locations = gradient.locations
        gradientLayer.type = gradient.type
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}

extension UIColor {
    public static func gradientColor(bounds: CGRect, gradient: FGradient) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = gradient.colors.map(\.cgColor)
        // This makes it left to right, default is top to bottom
        gradientLayer.startPoint = gradient.startPoint
        gradientLayer.endPoint = gradient.endPoint
        gradientLayer.locations = gradient.locations
        gradientLayer.type = gradient.type
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
        return UIColor(patternImage: image)
    }

}
