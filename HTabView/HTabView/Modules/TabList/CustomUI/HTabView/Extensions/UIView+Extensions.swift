//
//  UIView+Extensions.swift
//  HTabView
//
//  Created by Yevhen Tretiakov on 19.08.2022.
//

import UIKit

extension UIView {
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = false
        }
    }
    
    func makeRounded() {
        self.cornerRadius = self.frame.height / 2
    }
    
    func center(relativeTo view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
