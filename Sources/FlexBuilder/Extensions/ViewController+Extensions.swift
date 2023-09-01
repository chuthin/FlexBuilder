//
//  ViewController+Extensions.swift
//  FlexBuilder
//
//  Created by Chu Thin on 01/09/2023.
//

import UIKit
extension UIViewController {
  private class var sharedApplication: UIApplication? {
    let selector = NSSelectorFromString("sharedApplication")
    return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
  }

  /// Returns the current application's top most view controller.
    public class var topMost: UIViewController? {
    guard let currentWindows = self.sharedApplication?.windows else { return nil }
    var rootViewController: UIViewController?
    for window in currentWindows {
      if let windowRootViewController = window.rootViewController, window.isKeyWindow {
        rootViewController = windowRootViewController
        break
      }
    }

    return self.topMost(of: rootViewController)
  }

}

extension UIViewController {
    /// Returns the top most view controller from given view controller's stack.
    public class func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }

        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
           pageViewController.viewControllers?.count == 1 {
            return topMost(of: pageViewController.viewControllers?.first)
        }

        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return topMost(of: childViewController)
            }
        }

        return viewController
    }

    public class func getParent(from viewController: UIViewController?, of childViewController: UIViewController?) -> UIViewController? {
        if let presentedViewController = viewController?.presentedViewController {
            if presentedViewController != childViewController {
                return getParent(from: presentedViewController, of: childViewController)
            }
        }

        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            if selectedViewController != childViewController {
                return getParent(from: selectedViewController, of: childViewController)
            }
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            if visibleViewController != childViewController {
                return getParent(from: visibleViewController, of: childViewController)
            }
        }

        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
           pageViewController.viewControllers?.count == 1, pageViewController.viewControllers?.first != childViewController {
            return getParent(from: pageViewController.viewControllers?.first, of: childViewController)
        }

        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController1 = subview.next as? UIViewController {
                if childViewController1 != childViewController {
                    return getParent(from: childViewController, of: childViewController1)
                }
            }
        }

        return viewController
    }
}


