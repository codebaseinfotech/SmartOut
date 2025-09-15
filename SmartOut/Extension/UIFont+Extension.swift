//
//  UIFont+Extension.swift
//  Memto
//
//  Created by Ankit Gabani on 31/12/24.
//

import Foundation
import UIKit

extension UIFont {
    
    struct AppFont {
        static var regular: String {
            return "Manrope-Regular"
        }
        static var extraLight: String {
            return "Manrope-ExtraLight"
        }

        static var light: String {
            return "Manrope-Light"
        }

        static var medium: String {
            return "Manrope-Medium"
        }

        static var semiBold: String {
            return "Manrope-SemiBold"
        }

        static var bold: String {
          return "Manrope-Bold"
        }

        static var extraBold: String {
          return "Manrope-ExtraBold"
        }

        static func mRegular(_ sized: CGFloat) -> UIFont { return UIFont(name: AppFont.regular, size: sized) ?? UIFont.systemFont(ofSize: sized)}
        static func mExtraLight(_ sized: CGFloat) -> UIFont { return UIFont(name: AppFont.extraLight, size: sized) ?? UIFont.systemFont(ofSize: sized)}
        static func mLight(_ sized: CGFloat) -> UIFont { return UIFont(name: AppFont.light, size: sized) ?? UIFont.systemFont(ofSize: sized)}
        static func mMedium(_ sized: CGFloat) -> UIFont { return UIFont(name: AppFont.medium, size: sized) ?? UIFont.systemFont(ofSize: sized)}
        static func mSemiBold(_ sized: CGFloat) -> UIFont { return UIFont(name: AppFont.semiBold, size: sized) ?? UIFont.systemFont(ofSize: sized)}
        static func mBold(_ sized: CGFloat) -> UIFont { return UIFont(name: AppFont.bold, size: sized) ?? UIFont.systemFont(ofSize: sized)}
        static func mExtraBold(_ sized: CGFloat) -> UIFont { return UIFont(name: AppFont.extraBold, size: sized) ?? UIFont.systemFont(ofSize: sized)}
    }
    
}
