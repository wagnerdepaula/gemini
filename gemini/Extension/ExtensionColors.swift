//
//  UIColor.swift
//  gemini
//
//  Created by Wagner De Paula on 2/10/21.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
    
    convenience init(_ hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    convenience init(_ hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    public var isDark: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white < 0.5
    }
    
}


struct Color {
    static let primary = UIColor(0xffffff)
    static let secondary = UIColor(0xcccccc)
    static let tertiary = UIColor(0x666666)
    static let background = UIColor(0x000000)
    
    static let red = UIColor(0xea3d00)
    static let green = UIColor(0x079E0D)
    
    static let pink = UIColor(0xAD1457)
    static let purple = UIColor(0x6A1B9A)
    static let blue = UIColor(0x283593)
    static let cyan = UIColor(0x26ddf9)
    static let teal = UIColor(0x1DE9B6)
    static let lime = UIColor(0xC6FF00)
    static let yellow = UIColor(0xFFEA00)
    static let orange = UIColor(0xFF9100)
    static let charcoal = UIColor(0x111111)
}
