//
//  String+Extensions.swift
//  HTabView
//
//  Created by user on 19.08.2022.
//

import UIKit

extension String {
    var textWidth: CGFloat {
        return self.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width
    }
}
