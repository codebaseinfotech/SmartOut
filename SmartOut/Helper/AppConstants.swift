//
//  AppConstants.swift
//  Loyactive
//
//  Created by iMac on 11/08/23.
//

import Foundation
import UIKit

class LBUtulites {
    static let userDefualts = UserDefaults.standard
    
    class func isSaveUserLogin(isLogin: Bool, isConfirmUpdate: Bool) {
        LBUtulites.userDefualts.set(isLogin, forKey: "isCurrentUser")
        LBUtulites.userDefualts.set(isConfirmUpdate, forKey: "isConfirmUpdate")
    }
    
    class func getUserLogin() -> (isLogin: Bool, isConfirmUpdate: Bool) {
        let isLogin = LBUtulites.userDefualts.bool(forKey: "isCurrentUser")
        let isConfirmUpdate = LBUtulites.userDefualts.bool(forKey: "isConfirmUpdate")
        return (isLogin, isConfirmUpdate)
    }
    
    class func isSaveUserDetails(isUploadPic: Bool = false, isUploadUserDetails: Bool = false, isUploadDOB: Bool = false, isUploadFewDetails: Bool = false, isHowYouEarn: Bool = false, isUploadPicCollection: Bool = false) {
        LBUtulites.userDefualts.set(isUploadPic, forKey: "isUploadPic")
        LBUtulites.userDefualts.set(isUploadUserDetails, forKey: "isUploadUserDetails")
        LBUtulites.userDefualts.set(isUploadDOB, forKey: "isUploadDOB")
        LBUtulites.userDefualts.set(isUploadFewDetails, forKey: "isUploadFewDetails")
        LBUtulites.userDefualts.set(isHowYouEarn, forKey: "isHowYouEarn")
        LBUtulites.userDefualts.set(isUploadPicCollection, forKey: "isUploadPicCollection")
    }
    
    class func getUserDetails() -> (isUploadPic: Bool, isUploadUserDetails: Bool, isUploadDOB: Bool, isUploadFewDetails: Bool, isHowYouEarn: Bool, isUploadPicCollection: Bool) {
        let isUploadPic = LBUtulites.userDefualts.bool(forKey: "isUploadPic")
        let isUploadUserDetails = LBUtulites.userDefualts.bool(forKey: "isUploadUserDetails")
        let isUploadDOB = LBUtulites.userDefualts.bool(forKey: "isUploadDOB")
        let isUploadFewDetails = LBUtulites.userDefualts.bool(forKey: "isUploadFewDetails")
        let isHowYouEarn = LBUtulites.userDefualts.bool(forKey: "isHowYouEarn")
        let isUploadPicCollection = LBUtulites.userDefualts.bool(forKey: "isUploadPicCollection")
        return (isUploadPic, isUploadUserDetails, isUploadDOB, isUploadFewDetails, isHowYouEarn, isUploadPicCollection)
    }
    
}
