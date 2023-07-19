//
//  UIView+Extensions.swift
//  FlexBuilder
//
//  Created by Chu Thin on 14/07/2023.
//

import Foundation
import UIKit
import FlexLayout
extension UITextView {
    @discardableResult
    public func font(_ font:UIFont?) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    public func text(_ text:String) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    public func attributedText(_ text:NSMutableAttributedString) -> Self {
        self.attributedText = text
        return self
    }

    @discardableResult
    public func textAlignment(_ aligment:NSTextAlignment) -> Self {
        self.textAlignment = aligment
        return self
    }

    @discardableResult
    public func color(_ color:UIColor) -> Self {
        self.textColor = color
        return self
    }
}

extension UILabel {
    @discardableResult
    public func color(_ color:UIColor?) -> Self {
        self.textColor = color
        return self
    }
    @discardableResult
    public func alignment(_ aligment:NSTextAlignment) -> Self {
        self.textAlignment = aligment
        return self
    }

    @discardableResult
    public func attributedText(_ value:NSAttributedString) -> Self {
        self.attributedText = value
        return self
    }


    @discardableResult
    public func numberOfLines(_ value:Int) -> Self {
        self.numberOfLines = value

        return self
    }

    @discardableResult
    public func font(_ font:UIFont?) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    public func text(_ text:String) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    public func attributedText(_ text:NSMutableAttributedString) -> Self {
        self.attributedText = text
        return self
    }

    @discardableResult
    public func lineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) -> Self {

        guard let labelText = self.text else { return self }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
        return self
    }

    @discardableResult
    public func underline() -> Self {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
        return self
    }

}




extension UIButton {
    @discardableResult
    public func title(_ tỉtle:String) -> Self {
        self.setTitle(tỉtle, for: [])
        return self
    }

    /*@discardableResult
    public func absoluteTitle(_ value: String) -> Self {
        return self.asVStack {
            Text(value).textAlignment(.center)
                .position(value: .absolute)
                .font(self.titleLabel?.font)
                .textColor(self.titleLabel?.textColor)
                .left(0).right(0).top(0).bottom(0)
                .isUserInteractionEnabled(false)
        }
    }*/

    @discardableResult
    public func absoluteTitle(_ value: Bool) -> Self {
        //self.titleLabel?.position(value: value ? .absolute : .relative).textAlignment(.center).left(0).right(0).top(0).bottom(0)
        return self
    }

    /*public func absoluteTitle(_ value: UILabel) -> Self {
        return self.asVStack {
            value.textAlignment(.center)
                .position(value: .absolute)
                .left(0).right(0).top(0).bottom(0)
                .isUserInteractionEnabled(false)
        }
    }*/

    @discardableResult
    public func titleColor(_ color:UIColor) -> Self {
        self.setTitleColor(color, for: [])
        return self
    }
    @discardableResult
    public func image(_ image:UIImage?) -> Self {
        self.setImage(image, for: [])
        return self
    }
    @discardableResult
    public func backgroundImage(_ image: UIImage) -> Self {
        self.setBackgroundImage(image, for: [])
        return self
    }
    @discardableResult
    public func font(_ font:UIFont?) -> Self {
        self.titleLabel?.font = font
        return self
    }

    @discardableResult
    public func underline() -> Self {
        self.titleLabel?.underline()
        return self
    }
    @discardableResult
    public func disableBackgroundColor(_ color:UIColor) -> Self {
        self.backgroundColor = color
        return self
    }

    public func titleColor(_ color:UIColor,for state: UIControl.State) -> Self {
        self.setTitleColor( color, for: state)
        return self
    }
    /*
    @discardableResult
    public func isEnabled(_ isEnabled:Bool) -> Self {
        self.isEnabled = isEnabled
        if isEnabled{
            for layer in self.stretchLayers ?? []{
                layer.isHidden = false
            }
        } else {
            for layer in self.stretchLayers ?? []{
                layer.isHidden = true
            }
        }
        return self
    }*/

    /*@discardableResult
    public func enable(_ value:Bool) -> Self {
        self.isEnabled = value

        return self
    }*/

    @discardableResult
    public func titleEdgeInsets(_ value:UIEdgeInsets) -> Self {
        self.titleEdgeInsets = value
        self.contentEdgeInsets = value
        return self
    }


}



extension UITextField {
    @discardableResult
    public func text(_ text:String) -> Self {
        self.text = text
        return self
    }
    @discardableResult
    public func textColor(_ color:UIColor) -> Self {
        self.textColor = color
        return self
    }
    @discardableResult
    public func font(_ font:UIFont?) -> Self {
        self.font = font
        return self
    }
    @discardableResult
    public func placeHolder(_ text: String) -> Self {
        self.placeholder = text
        return self
    }
    @discardableResult
    public func backGround(_ image: UIImage) -> Self {
        self.background = image
        return self
    }

    @discardableResult
    public func textAlignment(_ aligment:NSTextAlignment) -> Self {
        self.textAlignment = aligment
        return self
    }
    @discardableResult
    public func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        self.borderStyle = style
        return self
    }
    @discardableResult
    public func keyboardType(_ type:UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }

    @discardableResult
    public func isSecureTextEntry(_ value:Bool) -> Self {
        self.isSecureTextEntry = value
        return self
    }
}

extension UIView {
    @discardableResult
    public func backgroundColor(_ color:UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    @discardableResult
    public func alpha(_ value:CGFloat) -> Self {
        self.alpha = value
        return self
    }

    @discardableResult
    public func display(_ value:Flex.Display) -> Self {
        self.flex.display(value)
        return self
    }

    @discardableResult
    public func hidden(_ value:Bool) -> Self {
        self.flex.display(value ? .none : .flex)
        return self
    }


    @discardableResult
    public func cornerRadius(_ value:CGFloat) -> Self {
        self.layer.cornerRadius = value
        return self
    }
    @discardableResult
    public func shadow(_ color:UIColor,_ size:CGSize,_ opacity:Float,_ radius:CGFloat) -> Self {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        return self
    }
    @discardableResult
    public func shadow(_ color:UIColor,_ size:CGFloat,_ opacity:Float,_ radius:CGFloat) -> Self {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: size, height: size)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        return self
    }
    @discardableResult
    public func boder(_ color:UIColor,_ width:CGFloat) -> Self {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        return self
    }
    @discardableResult
    public func tintColor(_ value:UIColor) -> Self {
        self.tintColor = value
        return self
    }

    @discardableResult
    public func clipsToBounds(_ value:Bool) -> Self {
        self.clipsToBounds = value
        return self
    }
    @discardableResult
    public func contentMode(_ value:UIView.ContentMode) -> Self {
        self.contentMode = value
        return self
    }

    @discardableResult
    public func tag(_ tag:String) -> Self {
        self.tag = tag.hashValue
        return self
    }
    @discardableResult
    public func tag(_ tag:Int) -> Self {
        self.tag = tag
        return self
    }
}


extension UISwitch{
    @discardableResult
    public func onImage(_ image:UIImage) -> Self{
        self.onImage = image
        return self
    }
    @discardableResult
    public func offImage(_ image:UIImage) -> Self{
        self.offImage = image
        return self
    }
    @discardableResult
    public func onTintColor(_ color:UIColor) -> Self {
        self.onTintColor = color
        return self
    }
    @discardableResult
    public func thumbTintColor(_ color:UIColor) -> Self {
        self.thumbTintColor = color
        return self
    }


}

extension UISlider{
    @discardableResult
    public func minimumValue(_ value: Float) -> Self {
        self.minimumValue = value
        return self
    }
    @discardableResult
    public func maximumValue(_ value: Float) -> Self {
        self.maximumValue = value
        return self
    }

}


extension UISegmentedControl {
    @discardableResult
    public func selectedSegmentIndex(_ index: Int)-> Self {
        self.selectedSegmentIndex = index
        return self
    }
}


extension UIDatePicker{
    @discardableResult
    public func datePickerMode(_ mode:UIDatePicker.Mode )-> Self{
        self.datePickerMode = mode
        return self
    }
    @discardableResult
    public func timeZone(_ timeZone:TimeZone?)-> Self{
        self.timeZone = timeZone
        return self
    }
    @discardableResult
    public func minimumDate(_ date:Date?)-> Self{
        self.minimumDate = date
        return self
    }
    @discardableResult
    public func maximumDate(_ date:Date?)-> Self{
        self.maximumDate = date
        return self
    }

}


extension UIImageView{
    @discardableResult
    public func image(_ image:UIImage)-> Self{
        self.image = image
        return self
    }

    @discardableResult
    public func setImageColor(color: UIColor) -> Self {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
      return self
    }
}

extension UIStepper{
    @discardableResult
    public func value(_ value: Double)-> Self {
        self.value = value
        return self
    }
    @discardableResult
    public func minimumValue(_ value: Double)-> Self {
        self.minimumValue = value
        return self
    }
    @discardableResult
    public func maximumValue(_ value: Double)-> Self {
        self.maximumValue = value
        return self
    }
    @discardableResult
    public func stepValue(_ value: Double)-> Self {
        self.stepValue = value
        return self
    }

}

extension UIPageControl{
    @discardableResult
    public func numberOfPages(_ value: Int)-> Self {
        self.numberOfPages = value
        return self
    }
    @discardableResult
    public func currentPage(_ value: Int)-> Self {
        self.currentPage = value
        return self
    }
    @discardableResult
    public func pageIndicatorTintColor(_ color:UIColor)->Self {
        self.pageIndicatorTintColor = color
        return self
    }
    @discardableResult
    public func currentPageIndicatorTintColor(_ color:UIColor)->Self {
        self.currentPageIndicatorTintColor = color
        return self
    }

}

extension UIProgressView{
    @discardableResult
    public func progressViewStyle(_ style: UIProgressView.Style)->Self {
        self.progressViewStyle = style
        return self
    }
    @discardableResult
    public func progressTintColor(_ color:UIColor)->Self {
        self.progressTintColor = color
        return self
    }
    @discardableResult
    public func trackTintColor(_ color:UIColor)->Self {
        self.trackTintColor = color
        return self
    }
    @discardableResult
    public func progressImage(_ image:UIImage)-> Self{
        self.progressImage = image
        return self
    }
    @discardableResult
    public  func trackImage(_ image:UIImage)-> Self{
        self.trackImage = image
        return self
    }


}


/*
extension UIView {

    public class func setupSwizzling() {
        struct Static {
            static var swizzled = false
        }

        if Static.swizzled {
            return
        } else {
            Static.swizzled = true
        }

        if self !== UIView.self { return }

        let originalSelector = #selector(layoutSubviews)
        let swizzledSelector = #selector(swizzling_layoutSubviews)

        let originalMethod = class_getInstanceMethod(UIView.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
        UIButton.swizzleLayoutSubviews()
    }

    @objc dynamic public func swizzling_layoutSubviews() {
        //guard Thread.isMainThread else { return }
        swizzling_layoutSubviews()
        if let layers = self.stretchLayers {
            for layer in layers {
                layer.frame = self.bounds
            }
        }
    }
}*/

/*
extension UIButton {
    public class func swizzleLayoutSubviews() {
        swizzle(selector: #selector(layoutSubviews),
                with: #selector(swizzling_button_layoutSubviews),
                inClass: UIButton.self,
                usingClass: UIButton.self)
    }

    @objc dynamic public func swizzling_button_layoutSubviews() {
        //guard Thread.isMainThread else { return }
        swizzling_button_layoutSubviews()
        if let layers = self.stretchLayers {
            for layer in layers {
                layer.frame = self.bounds
            }

        }
    }
}


public struct GradientStyle {
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

extension UIView {

    public struct StrechLayer {
        static var key = "strech_layer"
    }

    public var stretchLayers: [CALayer]? {
        get {
            return objc_getAssociatedObject(self, &StrechLayer.key) as? [CALayer]
        }
        set {
            objc_setAssociatedObject(self, &StrechLayer.key,
                                     newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
     @discardableResult
    public func background(_ gradient:GradientStyle) -> Self{
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
        return self
    }
     @discardableResult
    public func backgroundGradient(colors:[UIColor],startPoint:CGPoint = CGPoint(x: 0, y: 0), endPoint:CGPoint = CGPoint(x: 1, y: 0), locations:[NSNumber] = [0.0 , 1.0], type: CAGradientLayerType = .axial) -> Self {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors.map{ $0.cgColor}
        gradient.type = gradient.type
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
        if(stretchLayers == nil){
            stretchLayers = []
        }
        self.stretchLayers?.append(gradient)
        return self
    }

    @discardableResult
    public func background(_ image:UIImage, contentsGravity:CALayerContentsGravity = .resizeAspectFill) -> Self{
        //self.backgroundColor = UIColor(patternImage: image)
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage

        imageLayer.contentsGravity = contentsGravity
        if(stretchLayers == nil){
            stretchLayers = []
        }
        self.layer.insertSublayer(imageLayer, at: 0)
        self.stretchLayers?.append(imageLayer)
        return self
    }

    @discardableResult
    public func backgroundWithPadding(_ image:UIImage, contentsGravity:CALayerContentsGravity = .resizeAspectFill) -> Self{
        //self.backgroundColor = UIColor(patternImage: image)
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.borderWidth = 50
        imageLayer.borderColor = UIColor.clear.cgColor
        imageLayer.contentsGravity = .resizeAspectFill
        if(stretchLayers == nil){
            stretchLayers = []
        }
        self.layer.insertSublayer(imageLayer, at: 0)
        self.stretchLayers?.append(imageLayer)
        return self
    }

    @discardableResult
    public func addFlowerLayer(_ image: UIImage) -> Self {
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage

        imageLayer.contentsGravity = .resizeAspect
        if(stretchLayers == nil){
            stretchLayers = []
        }
        self.layer.insertSublayer(imageLayer, at: 0)
        self.stretchLayers?.append(imageLayer)
        return self
    }

    @discardableResult
    public func addFlowerLogoView(_ image: UIImage) -> Self {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        addSubview(imageView)
        return self
    }
}


func swizzle(selector originalSelector: Selector, with swizzledSelector: Selector, inClass: AnyClass, usingClass: AnyClass) {
    guard let originalMethod = class_getInstanceMethod(inClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(usingClass, swizzledSelector)
        else { return }

    if class_addMethod(inClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)) {
        class_replaceMethod(inClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
*/
extension DispatchQueue {
    private static var _onceTracker = [String]()

    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        guard !_onceTracker.contains(token) else { return }

        _onceTracker.append(token)
        block()
    }
}


extension UIView {
    @discardableResult
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) -> Self {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
        }
        else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
        return self
    }
}

extension UIView {
    public func removeAllSubview() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
extension UIView {

     public func takeScreenshot() -> String? {
        //print(self.frame)
        //print(self.frame.maxY)
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let content = image?.pngData()?.base64EncodedString(options: .endLineWithCarriageReturn)
        return content
    }
}

extension UITextField {
    public func textEndValue(_ value:String) {
        self.text = value
        self.sendActions(for: .editingChanged)
        self.sendActions(for: .editingDidEnd)
    }

    public func textValue(_ value:String) {
        self.text = value
        self.sendActions(for: .editingChanged)
    }
}
