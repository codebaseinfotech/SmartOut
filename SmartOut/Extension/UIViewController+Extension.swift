//
//  UIViewController+Extension.swift
//  Love Bite
//
//  Created by Ankit Gabani on 25/08/25.
//

import UIKit

extension UIViewController {
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func goBack(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func goDismiss(animated: Bool = true) {
        self.dismiss(animated: animated)
    }
    
    func presentVC(_ viewController: UIViewController, animated: Bool = true) {
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: animated)
    }
    
    func changeTab(tab: Int = 1) {
        var vc = UIViewController()
        
        if tab == 1 {
//            vc = HomeVC()
        } else if tab == 2 {
//            vc = FavoritesVC()
        } else if tab == 3 {
//            vc = WalletVC()
        } else if tab == 4 {
//            vc = ProfileVC()
        }
        
        self.push(vc, animated: false)
    }
    
}


extension UIViewController {
    
    // Show loader
    func showActivityIndicator(style: UIActivityIndicatorView.Style = .large) {
        // Check if already added
        if let _ = view.viewWithTag(999999) { return }
        
        // Create background overlay
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor(white: 0, alpha: 0.4)
        overlay.tag = 999999
        
        // Create activity indicator
        let indicator = UIActivityIndicatorView(style: style)
        indicator.center = overlay.center
        indicator.startAnimating()
        
        overlay.addSubview(indicator)
        view.addSubview(overlay)
    }
    
    // Hide loader
    func hideActivityIndicator() {
        if let overlay = view.viewWithTag(999999) {
            overlay.removeFromSuperview()
        }
    }
}
