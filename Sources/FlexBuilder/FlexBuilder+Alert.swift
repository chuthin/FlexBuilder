//
//  FlexBuilder+Alert.swift
//  BuilderUI
//
//  Created by Chu Thin on 17/07/2023.
//

import UIKit

public struct FAlert: BuilderViewController {
    public var viewController: UIViewController {
        return modifiableView.viewController
    }

    public var modifiableView: BuilderAlertViewControllerHostView
    
    public init<T>(_ data:T, _ view: (T) -> FView) {
        modifiableView = BuilderAlertViewControllerHostView(BuilderAlertViewController())
        modifiableView.setContainerView(view(data).build())
    }
    
    public init(title:String? = nil, message:String? = nil,actions:[FAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        for action in actions {
            alert.addAction(action.raw)
        }
        modifiableView = BuilderAlertViewControllerHostView(alert)
    }
    
    public init(title:String? = nil, message:String? = nil,@AlertActionBuilder _ builder: () -> [FAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        for action in builder() {
            alert.addAction(action.raw)
        }
        modifiableView = BuilderAlertViewControllerHostView(alert)
    }
}

@resultBuilder public struct AlertActionBuilder {
    public static func buildBlock() -> [FAlertAction] {
        []
    }
    public static func buildBlock(_ values: FAlertAction...) -> [FAlertAction] {
        values
    }
}

public enum FAlertAction {
    case `default`(String?,action: (() -> Void)? = nil)
    case cancel(String?,action: (() -> Void)? = nil)
    case destructive(String?,action: (() -> Void)? = nil)
}

extension FAlertAction {
    var raw:UIAlertAction {
        switch self {
        case .default(let string,let action):
            return UIAlertAction(title: string, style: .default,handler: { _ in
                action?()
            })
        case .cancel(let string,let action):
            return UIAlertAction(title: string, style: .cancel,handler: { _ in
                action?()
            })
        case .destructive(let string,let action):
            return UIAlertAction(title: string, style: .destructive,handler: { _ in
                action?()
            })
        }
    }
}

public class BuilderAlertViewControllerHostView: UIView {
    var viewController:UIViewController
    
    public init(_ viewController:UIViewController) {

        self.viewController = viewController;
        super.init(frame: .zero)
    }
    
    public func dismis() {
        viewController.dismiss(animated: true)
    }

    public func setContainerView(_ view: UIView) {
        if let vc = viewController as? BuilderAlertViewController {
            vc.setContainerView(view)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BuilderViewController where Base == BuilderAlertViewControllerHostView {
    public func dismis() {
        modifiableView.dismis()
    }
}

public class BuilderAlertViewController : UIViewController {
    public var containerView: UIView?
    var effectView:UIVisualEffectView?
    var safeArea:Bool = true

    public func setContainerView(_ view: UIView) {
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        effectView = UIVisualEffectView(effect: darkBlur)
        self.view.addSubview(effectView!)
        containerView = view
        containerView?.backgroundColor(.white)
        self.view.addSubview(view)
    }

    func dismiss() {
        self.dismiss(animated: true)
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let containerView = containerView, let effectView = self.effectView{
            containerView.pin.width(330)
            effectView.pin.all()
            containerView.flex.layout(mode: .adjustHeight)
            containerView.pin.center()
        }
    }
}
