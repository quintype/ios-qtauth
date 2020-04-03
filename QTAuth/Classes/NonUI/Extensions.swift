//
//  Extensions.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 25/10/19.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(fromHex hex: String) {
        let hexString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension UIButton {
    func addBorder(width: CGFloat, radius: CGFloat, color: CGColor) {
        if self.backgroundColor == nil { self.backgroundColor = .clear }
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.borderColor = color
    }
}

// MARK: Helper property to test if a string is a valid email-id
extension String {
    var isValidEmailID: Bool {
        get {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: self)
        }
    }
}

public extension Encodable {
    var encodedToDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension UIViewController {
    func displayAlertWith(title: String, message: String, okTitle: String, cancelTitle: String? = nil, completionBlock: ((_ okPressed: Bool) -> ())? = nil) { // Optional callbacks are implicitly escaping
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { (ok) in
            completionBlock?(true)
        }
        alertController.addAction(okAction)
        if let cancelTitle = cancelTitle{
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (cancel) in
                completionBlock?(false)
            })
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    
    public func fillSuperview(with insets: UIEdgeInsets = .zero, toSafeAreaLayoutGuide: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            if toSafeAreaLayoutGuide {
                if #available(iOS 11.0, *) {
                    anchor(superview.safeAreaLayoutGuide.topAnchor, left: superview.safeAreaLayoutGuide.leftAnchor, bottom: superview.safeAreaLayoutGuide.bottomAnchor, right: superview.safeAreaLayoutGuide.rightAnchor, topConstant: insets.top, leftConstant: insets.left, bottomConstant: insets.bottom, rightConstant: insets.right, widthConstant: 0, heightConstant: 0)
                } else {
                    anchor(superview.topAnchor, left: superview.leftAnchor, bottom: superview.bottomAnchor, right: superview.rightAnchor, topConstant: insets.top, leftConstant: insets.left, bottomConstant: insets.bottom, rightConstant: insets.right, widthConstant: 0, heightConstant: 0)
                }
            } else {
                anchor(superview.topAnchor, left: superview.leftAnchor, bottom: superview.bottomAnchor, right: superview.rightAnchor, topConstant: insets.top, leftConstant: insets.left, bottomConstant: insets.bottom, rightConstant: insets.right, widthConstant: 0, heightConstant: 0)
            }
        }
    }
    
    @discardableResult public func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        NSLayoutConstraint.activate(anchors)
        return anchors
    }
    
    public func anchorDimensionsToView(_ view: UIView, widthMultiplier: CGFloat? = nil, heightMultiplier: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        
        if let widthMultiplier = widthMultiplier {
            anchors.append(widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: widthMultiplier))
        }
        if let heightMultiplier = heightMultiplier {
            anchors.append(heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier))
        }
        NSLayoutConstraint.activate(anchors)
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        self.anchorCenterXTo(view: superview, constant: constant)
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        self.anchorCenterYTo(view: superview, constant: constant)
    }
    
    public func anchorCenterXTo(view: UIView?, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = view?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYTo(view: UIView?, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = view?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
}
extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }
        guard let finalUrl = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: finalUrl, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
}
extension UIDatePicker {
    func setYearValidation() {
        let calendar = Calendar.current
        var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        minDateComponent.day = 01
        minDateComponent.month = 01
        minDateComponent.year = 1900
        let minDate = calendar.date(from: minDateComponent)
        self.minimumDate = minDate
    } }

