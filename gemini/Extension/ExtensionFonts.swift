//
//  ExtensionFonts.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import UIKit

func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
    if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
        return UIFont(descriptor: descriptor, size: fontSize)
    } else {
        return UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
}
