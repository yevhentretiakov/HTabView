//
//  String+Extensions.swift
//  HTabView
//
//  Created by user on 19.08.2022.
//

import UIKit

extension String {
    func textWidth(_ font: UIFont = .systemFont(ofSize: 17)) -> CGFloat {
        return self.size(withAttributes: [NSAttributedString.Key.font : font]).width
    }
}
