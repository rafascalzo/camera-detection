//
//  UIView+Extensions.swift
//  camera-detection
//
//  Created by Rafael Scalzo on 9/28/19.
//  Copyright © 2019 Rafael Scalzo. All rights reserved.
//

import Foundation
import UIKit
enum ShadowOptions {
    
    case leftBottom
    case leftTop
    case rightBottom
    case rightTop
    case bottom
    case top
    case left
    case right
}

enum ParentOption {
    
    case centerX
    case centerY
    case center
}

extension UIView {
    
    func makeConstraintsWithVisualFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func makeConstraintEqualTo(_ option: ParentOption, component: UIView) {
        switch option {
        case .centerX:
            addConstraint(NSLayoutConstraint(item: component, attribute:.centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            break
        case .centerY:
            addConstraint(NSLayoutConstraint(item: component, attribute:.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            break
        case .center:
            addConstraint(NSLayoutConstraint(item: component, attribute:.centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: component, attribute:.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            break
        }
    }
    
    static let blurEffectView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blur
    }()
    
    // MARK: - Add Shadow
    func addShadow(_ color : UIColor , shadowOptions : ShadowOptions) -> Void{
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 0.25
        self.layer.shadowOpacity = 0.77
        
        switch shadowOptions {
            
        case .top:
            self.layer.shadowOffset = CGSize(width: 0, height: -1)
            break
        case .bottom :
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            break
        case .left :
            self.layer.shadowOffset = CGSize(width: -1, height: 0)
            break
        case .right :
            self.layer.shadowOffset = CGSize(width: 1, height: 0)
            break
        case .leftBottom :
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            break
        case .leftTop :
            self.layer.shadowOffset = CGSize(width: -1, height: -1)
            break
        case .rightBottom :
            self.layer.shadowOffset = CGSize(width: 1, height: 1)
            break
        case .rightTop :
            self.layer.shadowOffset = CGSize(width: 1, height: -1)
            break
        }
    }
    
    // MARK: - Setup Light Borders
    func setupLightBorders(withColor color : UIColor) -> Void {
        layer.masksToBounds = true
        layer.borderColor = color.cgColor
        layer.borderWidth = 0.25
    }
    
    // MARK: - Make Circular
    func makeCircular(with diameter:CGFloat?) {
        if let diameter = diameter {
            layer.cornerRadius = diameter / 2
        }
    }
    
    // MARK: - Add Blur
    func addBlur() {
        UIView.blurEffectView.alpha = 0.5
        UIView.blurEffectView.frame = self.bounds
        addSubview(.blurEffectView)
    }
    
    // MARK: - Remove Blur
    func removeBlur() {
        UIView.blurEffectView.frame = .zero
        UIView.blurEffectView.removeFromSuperview()
    }
    
    // MARK: - Adjust Scale Image
    func adjustScaleImage() {
        self.contentMode = .scaleAspectFill
    }
}
