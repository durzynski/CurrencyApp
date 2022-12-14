//
//  String+Extensions.swift
//  Currency-SwiftUI
//
//  Created by Damian Durzyński on 09/12/2022.
//

import SwiftUI

extension String {
    func withColorAndFont(color: Color, font: Font, range: NSRange) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.font: font] as [NSAttributedString.Key : Any]
        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
}
