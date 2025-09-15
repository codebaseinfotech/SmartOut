//
//  UIView+Extension.swift
//  Memto
//
//  Created by Ankit Gabani on 31/12/24.
//

import Foundation
import UIKit
//import Toast_Swift

public enum ViewPoint {
    case none
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
    case centre

}
@IBDesignable extension UIView {

    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

    @IBInspectable public var shadowEnabled: Bool {
        get {
            return layer.shadowRadius > 0
        }
        set {
            if newValue {
                self.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
                self.layer.shadowRadius = cornerRadiusValue
                self.layer.shadowOpacity = 0.2
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.layer.masksToBounds = false
            } else {
                self.layer.shadowColor = UIColor.clear.cgColor
                self.layer.shadowRadius = cornerRadiusValue
                self.layer.shadowOpacity = 0
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
            }
        }
    }

    @IBInspectable public var shadowOpacity1: Float {
        get {
            return Float(layer.shadowRadius)
        }
        set {
            if newValue != 0 {
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowRadius = 5.0
                self.layer.shadowOpacity = newValue
                self.layer.shadowOffset = CGSize(width: -1, height: 1)
                // self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                self.layer.masksToBounds = false
            }
        }
    }

    func topCorner(maskToBounds: Bool = false) {
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius =  25
        self.layer.masksToBounds = maskToBounds
    }

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor =  UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 10

        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: UIRectCorner.allCorners,
                                        cornerRadii: CGSize(width: 8, height: 8)).cgPath
    }

   /* func showErrorMessage(message: String?) {
        CRNotificationPopup.showNotification(type: .error, title: "".localizedString, message: message ?? "", dismissDelay: 2)
    }*/

  /*  func showSuccessMessage(message: String?) {
        CRNotificationPopup.showNotification(type: .success, title: message ?? "", message: "", dismissDelay: 2)
    }*/

   /* func showInfoMessage(title: String?, message: String?) {
        let localizedMessage = message?.localizedString
        CRNotificationPopup.showNotification(type: .info, title: title ?? "", message: localizedMessage ?? "", dismissDelay: 2)
    }*/

    func dropSmallShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor =  UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 2

        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: UIRectCorner.allCorners,
                                        cornerRadii: CGSize(width: 8, height: 8)).cgPath
    }

    func addGradient(withColors colors: [CGColor] ) {
        for lay in self.layer.sublayers ?? [] where lay.name == "gradient" {
            lay.removeFromSuperlayer()
        }
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = colors
        gradient.name = "gradient"
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)

        self.layer.insertSublayer(gradient, at: 0)
    }

    @IBInspectable public var bgColorPrimary: Bool {
        get {
            return  self.backgroundColor == UIColor.AppColor.appBlack
        }
        set {
            if newValue {
                  self.backgroundColor = UIColor.AppColor.appBlack
            }
        }
    }

    @IBInspectable public var bgColorHighlight: Bool {
        get {
            return  self.backgroundColor == UIColor.AppColor.appBlack
        }
        set {
            if newValue {
                  self.backgroundColor = UIColor.AppColor.appBlack
            }

        }
    }
    @IBInspectable public var bgColorAccent: Bool {
        get {
            return  self.backgroundColor == UIColor.AppColor.appBlack
        }
        set {
            if newValue {
                  self.backgroundColor = UIColor.AppColor.appBlack
            }

        }
    }

    @IBInspectable var cornerRadiusValue: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

    @IBInspectable public var bgColorAccentSec: Bool {
        get {
            return  self.backgroundColor == UIColor.AppColor.appBlack
        }
        set {
            if newValue {
                  self.backgroundColor = UIColor.AppColor.appBlack
            }
        }
    }

    @IBInspectable public var bgColorAccentThird: Bool {
        get {
            return  self.backgroundColor == UIColor.AppColor.appBlack
        }
        set {
            if newValue {
                  self.backgroundColor = UIColor.AppColor.appBlack
            }

        }
    }

    @IBInspectable public var addTopCornerRedius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }

    @IBInspectable public var addBottomCornerRedius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }

    @IBInspectable public var addLeftCornerRedius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }

    @IBInspectable var shadowWithCornerRadius: Bool {
        get {
            return layer.shadowRadius > 0
        }
        set {
            if newValue {
                let shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadiusValue).cgPath
                shadowLayer.fillColor = UIColor.white.cgColor

                shadowLayer.shadowColor = UIColor(netHex: 0x1B1F44).withAlphaComponent(0.5).cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                shadowLayer.shadowOpacity = 0.8
                shadowLayer.shadowRadius = 1.5

                layer.insertSublayer(shadowLayer, at: 0)
            }
        }
    }

    var frameWidth: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
              self.frame.size.width =  newValue
        }
    }

    var frameHeight: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
              self.frame.size.height =  newValue
        }
    }

    var halfWidth: CGFloat {
        return self.frameWidth / 2
    }

    var halfHeight: CGFloat {
        return self.frameHeight / 2
    }

    var topLeft: CGPoint {
        get {
            return self.frame.origin
        }
        set {
              self.frame.origin =  newValue
        }
    }

    var topRight: CGPoint {
        get {
            return CGPoint.init(x: self.topLeft.x + self.frameWidth, y: self.topLeft.y)
        }
        set {
              self.topLeft = CGPoint.init(x: newValue.x - self.frameWidth, y: newValue.y)
        }
    }

    var bottomLeft: CGPoint {
        get {
            return CGPoint.init(x: self.topLeft.x, y: self.topLeft.y + self.frameHeight)
        }
        set {
              self.topLeft = CGPoint.init(x: newValue.x, y: newValue.y - self.frameHeight)
        }
    }

    var bottomRight: CGPoint {
        get {
            return CGPoint.init(x: self.bottomLeft.x + self.frameWidth, y: self.bottomLeft.y)
        }
        set {
              self.topLeft = CGPoint.init(x: newValue.x  - self.frameWidth, y: newValue.y - self.frameHeight)
        }
    }

    func alignToView(view: UIView, viewPoint: ViewPoint, offset: CGSize) {
        var centerPoint = CGPoint.zero

        switch viewPoint {
        case .topLeft:
            centerPoint = CGPoint.init(x: view.topLeft.x + offset.width, y: view.topLeft.y + offset.height)
        case .topRight:
            centerPoint = CGPoint.init(x: view.topRight.x + offset.width, y: view.topRight.y + offset.height)
        case .bottomLeft:
            centerPoint = CGPoint.init(x: view.bottomLeft.x + offset.width, y: view.bottomLeft.y + offset.height)
        case .bottomRight:
            centerPoint = CGPoint.init(x: view.bottomRight.x + offset.width, y: view.bottomRight.y + offset.height)
        default:
            centerPoint = CGPoint.zero
        }
        self.center = centerPoint
    }

    func alignToView(view: UIView, viewPoint: ViewPoint) {
        let offset = CGSize.init(width: self.halfWidth, height: self.halfHeight)
        self.alignToView(view: view, viewPoint: viewPoint, offset: offset)
    }

    func alignToCornerOfView(view: UIView, viewPoint: ViewPoint) {
        let offset = CGSize.zero
        self.alignToView(view: view, viewPoint: viewPoint, offset: offset)
    }

    func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint.init(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)

        var oldPoint = CGPoint.init(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)

        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)

        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        self.layer.position = position
        //        self.layer.anchorPoint = anchorPoint
    }

    /////////////////////////////////////////////

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    // Set Top CornerRadius to View
    func topCornerRadius(view: UIView, radius: CGFloat) {
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }

    func bottomCornerRadius(view: UIView, radius: CGFloat) {
        // view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }

    func addSubViewWithAnimation(subView: UIView) {
        subView.alpha = 0
        self.addSubview(subView)
        subView.frame = self.bounds
        UIView.animate(withDuration: 0.4) {
            subView.alpha = 1
        }
    }

    func removeSubViewWithAnimation(subView: UIView) {
        UIView.animate(withDuration: 0.4, animations: {
            subView.alpha = 0
        }) { (success) in
            if success {
                subView.removeFromSuperview()
            }
        }
    }

    func startShimmering() {
        let light = UIColor.red.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.4).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha, alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [1.0, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        self.layer.mask?.add(animation, forKey: "shimmer")
    }

    func stopShimmering() {
        self.layer.mask = nil
    }

    func rotate90(_ toValue: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: toValue)
    }

    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.3) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }

    private static let kLayerNameGradientBorder = "GradientBorderLayer"

    func setGradientBorder(
        width: CGFloat,
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    ) {
        let existedBorder = gradientBorderLayer()
        let border = existedBorder ?? CAGradientLayer()
        border.frame = bounds
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        border.cornerRadius = 8

        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width

        border.mask = mask

        let exists = existedBorder != nil
        if !exists {
            layer.addSublayer(border)
        }
    }

    func removeGradientBorder() {
        self.gradientBorderLayer()?.removeFromSuperlayer()
    }

    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }

}
@IBDesignable
class DashedLineView: UIView {
    @IBInspectable var perDashLength: CGFloat = 2.0
    @IBInspectable var spaceBetweenDash: CGFloat = 2.0
    @IBInspectable var dashColor: UIColor = UIColor.lightGray

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        if height > width {
            let  point0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: point0)

            let  point1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: point1)
            path.lineWidth = width

        } else {
            let  point0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: point0)

            let  point1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: point1)
            path.lineWidth = height
        }

        let dashes: [ CGFloat ] = [ perDashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)

        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }

    private var width: CGFloat {
        return self.bounds.width
    }

    private var height: CGFloat {
        return self.bounds.height
    }
}
extension UIView {

    func slideInFromRight(duration: TimeInterval = 0.5, direction: CATransitionSubtype, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()

        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate = completionDelegate {
            slideInFromLeftTransition.delegate = delegate as? any CAAnimationDelegate
        }

        // Customize the animation's properties
        slideInFromLeftTransition.type = CATransitionType.push
//        slideInFromLeftTransition.subtype = CATransitionSubtype.fromRight
        slideInFromLeftTransition.subtype = direction
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        slideInFromLeftTransition.fillMode = CAMediaTimingFillMode.removed

        // Add the animation to the View's layer
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }

    func hideViewAnimated( subviews: [UIView], hide: Bool, minimizeBtn: UIButton?, minimizeImage: UIImage?, expandImage: UIImage?, animated: Bool = true) {
        subviews.forEach { (view) in
            view.isHidden = hide
            view.alpha = 0
        }
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.layoutIfNeeded()

            subviews.forEach { (view) in
                view.alpha =   1
            }
            minimizeBtn?.setImage(hide ? minimizeImage : expandImage, for: .normal)
        }
    }

    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }

    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }

}

extension UIStackView {

}

extension UIView {
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = false
        rotation.repeatCount = Float.nan
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor: UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor: UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation: Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode: Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode: Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as? CAGradientLayer ?? CAGradientLayer() }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}


extension UIView {
    func applyGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.frame.height/2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)

    }
}


class RectangularDashedView: UIView {
    
    @IBInspectable var cornerRadius1: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius1
            layer.masksToBounds = cornerRadius1 > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius1 > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius1).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
    
    var parentController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

//extension UIViewController
//{
//    func setUpMakeToast(msg: String)
//    {
//        self.view.makeToast(msg)
//        let windows = UIApplication.shared.windows
//        windows.last?.makeToast(msg)
//    }
//
//    
//    func setUpHideMakeToast()
//    {
//        self.view.hideToast()
//        let windows = UIApplication.shared.windows
//        windows.last?.hideToast()
//    }
//
//}

extension UIView {
    func findSubview<T: UIView>(ofType type: T.Type, matching: ((T) -> Bool)? = nil) -> T? {
        for subview in subviews {
            if let match = subview as? T, matching?(match) ?? true {
                return match
            }
            if let match = subview.findSubview(ofType: type, matching: matching) {
                return match
            }
        }
        return nil
    }
}


extension UIView {
    enum BorderSide {
        case top, bottom, left, right
    }

    func addBorder(to side: BorderSide, color: UIColor = .lightGray, thickness: CGFloat = 1.0) {
        let border = CALayer()
        border.name = "borderLayer"
        border.backgroundColor = color.cgColor

        switch side {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: bounds.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: bounds.height - thickness, width: bounds.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: bounds.height)
        case .right:
            border.frame = CGRect(x: bounds.width - thickness, y: 0, width: thickness, height: bounds.height)
        }

        layer.addSublayer(border)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
