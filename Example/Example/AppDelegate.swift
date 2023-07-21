//
//  AppDelegate.swift
//  Example
//
//  Created by Chu Thin on 19/07/2023.
//

import UIKit



@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc  = ListRouteController([RouteItem(route: .layout(.all), title: "Layout"),
                                       RouteItem(route: .reactive(.all), title: "Reactive"),]).viewController

        window?.rootViewController = vc.buildNavigationController()
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backgroundColor(.white)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
      
        return true
    }
}



