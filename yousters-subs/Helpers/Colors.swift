//
//  Colors.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

extension UIColor {
    static let mainColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1)
    static let bgColor = UIColor(hex: "#1F1F1F")
    
    static let backgroundColor = UIColor(hex: "#F5F7FC")
    
    static let secondaryButtonColor = UIColor(hex: "#F5F7FC")
    
    static let whiteTransp = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    static let blackTransp = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

    static let buttonDisabled = UIColor(hex: "#585858")
    static let buttonHighlited = UIColor(hex: "#2D2D2D")
    
    static let secondaryButtonDisabled = UIColor(hex: "#fbfbfb")
    static let secondaryButtonHighlited = UIColor(hex: "#e7e9ec")
    
    static let redColor = UIColor(hex: "#DE4B31")
    
    static let bronzeColor = UIColor(hex: "#cd7f32")
    static let silverColor = UIColor(hex: "#c0c0c0")
    static let goldColor = UIColor(hex: "#ffd700")
    
    static let greenColor = UIColor(hex: "#60B841")
}





extension UIColor {
    public convenience init(hex: String) {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
