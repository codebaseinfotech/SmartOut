//
//  AppDelegate.swift
//  SmartOut
//
//  Created by iMac on 12/09/25.
//

import UIKit
import LGSideMenuController

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        let homeNavigation = UINavigationController(rootViewController: homeVC)
        homeNavigation.navigationBar.isHidden = true

        // SideBarVC from XIB
        let leftMenuVC = SideMenuVC(nibName: "SideMenuVC", bundle: nil)

        // LGSideMenuController setup
        let sideMenuController = LGSideMenuController(rootViewController: homeNavigation,
                                                      leftViewController: leftMenuVC,
                                                      rightViewController: nil)

        // Adjust menu width
        sideMenuController.leftViewWidth = UIScreen.main.bounds.width - 70
        sideMenuController.navigationController?.navigationBar.isHidden = true
        // Set as root
        window?.rootViewController = sideMenuController
        window?.makeKeyAndVisible()
        
        return true
    }


}

