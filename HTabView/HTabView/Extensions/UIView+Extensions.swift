//
//  UIView+Extensions.swift
//  HTabView
//
//  Created by user on 19.08.2022.
//

import UIKit

extension UIView {
    func makeRounded() {
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
    }
}
