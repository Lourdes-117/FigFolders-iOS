//
//  UIViewUtility.swift
//  FigFolders
//
//  Created by Lourdes on 5/10/21.
//

import UIKit

enum ShadowDirection: String {
    case bottom
    case top
    case right
    case left
    case all
}

enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

let kAnimationDuration = TimeInterval(0.25)

/// Returns Current User's email ID
var currentUserEmail: String? {
    get {
        return UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String
    }
}

/// Returns Current User's Username
var currentUserUsername: String? {
    get {
        return UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.userName) as? String
    }
}

extension UIView {
    
    func addAsSubViewWithEqualConstraintTo(_ containerView: UIView) {
        self.frame = containerView.bounds
        containerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            self.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0),
            self.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0)
            ])
    }
    
    func setRoundedCorners() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func addShadow(location: ShadowDirection, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 1), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -1), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -1, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 1, height: 0), color: color, opacity: opacity, radius: radius)
            
        case .all:
            addShadow(offset: CGSize(width: 0, height: 0), color: color, opacity: opacity, radius: radius)
            
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func removeShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 0.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
    }
    
    func commonInit(_ nibName: String) {
        guard let view = loadViewFromNib(nibName) else {
            return
        }
        view.addAsSubViewWithEqualConstraintTo(self)
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)

        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func updateViewVisibilityWithAnimation(_ views: [UIView: Bool]) {
        
        views.forEach { (view: UIView, isNeedToHide: Bool) in
            if !isNeedToHide {
                view.isHidden = false
            }
        }
        
        UIView.animate(withDuration: kAnimationDuration, animations: {
            views.forEach { (view: UIView, isNeedToHide: Bool) in
                view.alpha = isNeedToHide ? 0.0 : 1.0
            }
        }) { (_) in
            views.forEach { (view: UIView, isNeedToHide: Bool) in
                if isNeedToHide {
                    view.isHidden = true
                }
            }
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         self.layer.cornerRadius = radius
         self.clipsToBounds = true
         self.layer.masksToBounds = false
         if #available(iOS 11.0, *) {
             self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
         } else {
             let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
             let mask = CAShapeLayer()
             mask.path = path.cgPath
             self.layer.mask = mask
         }
     }
    
    func updateViewWithAnimation(_ viewUpdateFunc: (() -> Void)? = nil, _ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            viewUpdateFunc?()
            strongSelf.layoutIfNeeded()
            
        }) { (isAnimated) in
            if isAnimated {
                completion?()
            }
        }
    }
}

// MARK: - View Transition -

extension UIView {
    
    func fadeIn(_ completion: (() -> Void)? = nil) {
        guard isHidden else {
            return
        }
        
        alpha = 0.0
        isHidden = false
        UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.alpha = 1.0
        }) { (_) in
            completion?()
        }
    }
    
    func fadeOut(_ completion: (() -> Void)? = nil) {
        guard !isHidden else {
            return
        }
        
        UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.alpha = 0.0
        }) { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isHidden = true
            completion?()
        }
    }
    
    func addGradient(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topToBottom:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
   func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}

