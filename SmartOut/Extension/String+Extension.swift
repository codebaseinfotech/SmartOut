//
//  String+Extension.swift
//  Memto
//
//  Created by Ankit Gabani on 31/12/24.
//

import Foundation
import UIKit

extension Optional where Wrapped == String {
    var validString: String! {
        return self ?? ""
    }

    var isInValid: Bool {
        return self.validString.isEmpty
    }

    var isValid: Bool {
        return !self.isInValid
    }
}

extension NSMutableAttributedString {

    func setAttributesForText(textForAttribute: String, withColor color: UIColor? = nil, withFont: UIFont? = nil, shouldUnderLine: Bool = false) {

        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        if let color = color {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        if let font = withFont {
            self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        if shouldUnderLine {
            self.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
    }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }

    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }

    func utf8EncodedString() -> String {
        let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")

        let text = self.addingPercentEncoding(withAllowedCharacters: rfc3986Unreserved) ?? ""
         return text
    }

    var validString: String! {
        return  self
    }

    var isInValid: Bool {
        return self.validString.isEmpty
    }

    var isValid: Bool {

        return !self.isInValid
    }

    var isMobileNumberStartWithNonZero: Bool {
        let numbersArray = self.compactMap {Int(String($0))}
        return !(numbersArray.first == 0)
    }

    var isValidPassword: Bool {
        return validate(password: self)
    }

    func validate(password: String) -> Bool {
        var score = 0
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        if texttest.evaluate(with: password) { score = +1 }

        let smallLetterRegEx  = ".*[a-z]+.*"
        let texttest3 = NSPredicate(format: "SELF MATCHES %@", smallLetterRegEx)
        if texttest3.evaluate(with: password) {
            score += 1
        }

        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        if texttest1.evaluate(with: password) {
            score += 1
        }

        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegEx)
        if texttest2.evaluate(with: password) {
            score += 1
        }

        return score >= 3
    }

    public func isPasswordValid() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }

    var hasSpecialCharacters: Bool {

        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if regex.firstMatch(in: self,
                                options: NSRegularExpression.MatchingOptions.reportCompletion,
                                range: NSRange(location: 0, length: self.count)) != nil {
                return true
            }

        } catch {
            debugPrint(error.localizedDescription)
            return false
        }

        return false
    }

    func validMobile(minLength: Int, maxLength: Int) -> Bool {

        if minLength <= self.count && self.count <= maxLength {
            if self.first != nil {
                let allowedCharacters = CharacterSet(charactersIn: "0123456789").inverted
                let inputString = components(separatedBy: allowedCharacters)
                let filtered = inputString.joined(separator: "")
                return self == filtered
            }
        }
        return false
    }

    func validMobileCode(minLength: Int, maxLength: Int) -> Bool {
        if minLength <= self.count && self.count <= maxLength {
            let allowedCharacters = CharacterSet(charactersIn: "+123456789").inverted
            let inputString = components(separatedBy: allowedCharacters)
            let filtered = inputString.joined(separator: "")
            return self == filtered
        }
        return false
    }
//
//    var isAdult: Bool {
//        return Calendar.current.dateComponents([.year], from: self.dateFromFormat(.apiFormatShort)!, to: Date() ).year! >= 18
//    }

    func validateSpecialCharacters(_ string: String) -> Bool {
        return string.range(of: ".*[^A-Za-z0-9 ].*", options: .regularExpression) == nil
    }

    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date
    }

    var time: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: self)
        return date
    }

//    func dateFromFormat(_ format: DateFormats, timeZone: TimeZone? = nil) -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format.rawValue
//        if let timeZone =  timeZone {
//              dateFormatter.timeZone = timeZone
//        }
//        let date = dateFormatter.date(from: self)
//        return date
//    }
//
//    func dateFormatter(_ fromFormat: DateFormats = .apiFormatLong, toFormat: DateFormats) -> String {
//        let dateFormatter = DateFormatter()
//        let date = self.dateFromFormat(fromFormat)
//        dateFormatter.dateFormat = toFormat.rawValue
//        guard let postedDate = date else {return self}
//        return dateFormatter.string(from: postedDate)
//    }
//
//    func dateFormatterWidget(_ fromFormat: DateFormats = .apiFormatLong, toFormat: DateFormats) -> String {
//        let dateFormatter = DateFormatter()
//        let date = self.dateFromFormat(fromFormat)
//        dateFormatter.dateFormat = toFormat.rawValue
//        dateFormatter.locale = Locale(identifier: "en_US")
//        guard let postedDate = date else {return self}
//        return dateFormatter.string(from: postedDate)
//    }

    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd MMMM yyyy"
        guard let postedDate = date else {return self}
        return dateFormatter.string(from: postedDate)
    }

    func shortDate(forString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: forString)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMMM d, yyyy"
        guard let postedDate = date else {return forString}
        return dateFormatter.string(from: postedDate)
    }

    func toUSD() -> String {
        let usd = "$" + self
        return usd
    }

    func toEUR() -> String {
        let eur = "€" + self
        return eur
    }

    func toGBP() -> String {
        let gbp = "£" + self
        return gbp
    }

}

extension String {
     func getHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

     func getWidth(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)

        return ceil(boundingBox.width)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}


extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
