//
//  AppDelegate.swift
//  BounceDemos
//
//  Created by Irem Karaoglu on 24.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            
            window = UIWindow(frame:UIScreen.main.bounds)
            let rootvc = ViewController()
            let navVC = UINavigationController(rootViewController: rootvc)
            window?.rootViewController = navVC
            window?.makeKeyAndVisible()
            
            return true
        }


}

