//
//  FlexBuilder+ViewController.swift
//  FlexBuilder
//
//  Created by Chu Thin on 11/07/2023.
//

import UIKit
import RxSwift
import PinLayout
public protocol ViewControllerBuilder : ModifiableView {
    var viewController: UIViewController { get }
}

public protocol ControllerBuilder : ViewBuilder {
    func view() -> any ViewControllerBuilder
}

public struct FViewController: ViewControllerBuilder {
    public var viewController: UIViewController {
        return modifiableView.viewController
    }

    public var modifiableView = BuilderInternalViewControllerHostView()

    public init(safeArea:Bool = true,_ view: () -> FView) {
        let vc = view()
        modifiableView.viewController.setContainerView(safeArea,vc.build())
    }
}

public class BuilderInternalViewControllerHostView: UIView {
    var viewController = BuilderHostViewController()
    public var navigationBarIsHidden : Bool = false
    public init() {
        super.init(frame: .zero)
        viewController.view.backgroundColor(.white)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func dispose(by disposeBag:DisposeBag) {
        self.viewController.disposeBag = disposeBag
    }
}

extension UIViewController {
    var builderContainerView: UIView? {
        return self.view.viewWithTag(UIViewController.BuilderContainerTag.hashValue)
    }
    
    public static let BuilderContainerTag = "BUILDER_CONTAINER_TAG"
}

extension ViewControllerBuilder where Base == BuilderInternalViewControllerHostView {
    public func dispose(by disposeBag:DisposeBag) {
        self.modifiableView.dispose(by:disposeBag)
    }
}

public class BuilderHostViewController : UIViewController {
    #if DEBUG
    public var builder: (any ControllerBuilder)?
    #endif
    var onViewWillAppear:(() -> Void)?
    var onViewWillDisappear:(() -> Void)?
    var onViewDidLoad:(() -> Void)?
    public var containerView: UIView?
    public var disposeBag = DisposeBag()
    var safeArea:Bool = true
    public func setContainerView(_ safeArea:Bool,_ view: UIView) {
        containerView = view
        containerView?.tag(UIViewController.BuilderContainerTag)
        self.view.backgroundColor(.white)
        self.safeArea = safeArea
        self.view.addSubview(view)
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView?.pin.all(safeArea ? self.view.pin.safeArea : UIEdgeInsets())
        self.containerView?.flex.layout()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppear?()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onViewWillDisappear?()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad?()
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

public extension ControllerBuilder {
    var body: FView  {
        return self.view()
    }

    var viewController: UIViewController {
        return view().viewController
    }
}

extension ViewControllerBuilder where Base : BuilderInternalViewControllerHostView {
    @discardableResult
    public func title(_ value: String) -> Self {
        self.viewController.title = value
        return self
    }

    @discardableResult
    public func viewDidLoad(_ hanlde: @escaping () -> Void) -> Self {
        self.modifiableView.viewController.onViewDidLoad = hanlde
        return self
    }

    @discardableResult
    public func viewWillDisappear(_ hanlde: @escaping () -> Void) -> Self {
        self.modifiableView.viewController.onViewWillDisappear = hanlde
        return self
    }

    @discardableResult
    public func viewWillAppear(_ hanlde: @escaping () -> Void) -> Self {
        self.modifiableView.viewController.onViewWillAppear = hanlde
        return self
    }

    public func barStyle(_ statusBarStyle: UIBarStyle) -> Self {

        return self
    }

    @discardableResult
    public func rightBarButtonItems(@ViewResultBuilder _ builder: () -> ViewConvertable) -> Self {
        var rightBarButtonItems:[UIBarButtonItem] = []
        builder().asViews().forEach {
            rightBarButtonItems.append(UIBarButtonItem(customView: $0.build()))
        }
        self.viewController.navigationItem.rightBarButtonItems = rightBarButtonItems
        return self
    }

    @discardableResult
    public func leftBarButtonItems(@ViewResultBuilder _ builder: () -> ViewConvertable) -> Self {
        var leftBarButtonItems:[UIBarButtonItem] = []
        builder().asViews().forEach {
            leftBarButtonItems.append(UIBarButtonItem(customView: $0.build()))
        }
        self.viewController.navigationItem.leftBarButtonItems = leftBarButtonItems
        return self
    }


    @discardableResult
    public func alert<T>(_ item:Observable<T?>, _ builder: @escaping (T) -> any ViewControllerBuilder) -> Self {
        item.observe(on: MainScheduler.instance)
            .filter{ $0 != nil}
            .subscribe(onNext:{[weak viewController] item in
                let vc = builder(item!).viewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                viewController?.present(vc, animated: true)
            })
            .disposed(by: self.viewController.rxDisposeBag)

        return self
    }
}
