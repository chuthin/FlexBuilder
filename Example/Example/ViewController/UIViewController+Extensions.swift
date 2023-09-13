//
//  UIViewController+Extensions.swift
//  Example
//
//  Created by Chu Thin on 13/09/2023.
//

import Foundation
import FlexBuilder
public extension UIViewController {
    func buildNavigationController() -> BuilderNavigagionViewController {
        let navController = BuilderNavigagionViewController(rootViewController: self)
        return navController
    }
}

final public  class BuilderNavigagionViewController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        //navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
        navigationBar.tintColor = .white
        navigationBar.barTintColor = .white

        #if DEBUG
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(onInjected),
                                                   name: NSNotification.Name(rawValue: "INJECTION_BUNDLE_NOTIFICATION"),
                                                   object: nil)
        #endif
    }

    @objc func onInjected() {
         if let currentViewController = UIViewController.topMost {
             if self.viewControllers.contains(currentViewController) {
                 if self.viewControllers.count == 1 {
                     if let uiViewController = self.viewControllers.first as? BuilderHostViewController,
                        let builder = uiViewController.builder as? (any ReloadViewBuilder) {
                         let controller = builder.createInstance.view().viewController
                         self.setViewControllers([controller], animated: false)
                     }
                 } else {
                     if let uiViewController = self.popViewController(animated: false) as? BuilderHostViewController {
                         if let builder = uiViewController.builder as? (any ReloadViewBuilder) {
                             let controller = builder.createInstance.view().viewController
                             self.pushViewController(controller, animated: false)
                         }
                     }
                 }
             } else {
                 if let currentViewController = currentViewController as? BuilderHostViewController,
                        let uiViewController = self.viewControllers.last as? BuilderHostViewController

                      {
                        uiViewController.dismiss(animated: false, completion: nil)
                     if let builder = currentViewController.builder as? (any ReloadViewBuilder) {
                         uiViewController.present(builder.createInstance.view().viewController, animated: false)
                     }
                 }
             }

         }
    }
}

public extension ControllerBuilder {
    func buildNavigationController() -> BuilderNavigagionViewController {
        return viewController.buildNavigationController()
    }
}
