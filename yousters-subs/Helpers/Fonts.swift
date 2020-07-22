//
//  Fonts.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 12.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class Fonts {
    private let gilroyRegularName = "Gilroy-Regular"
    private let gilroyMediumName = "Gilroy-Medium"
    private let gilroySemiBoldName = "Gilroy-SemiBold"
    
    func gilroyRegular(ofSize: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: gilroyRegularName, size: ofSize) else {
            return .systemFont(ofSize: ofSize)
        }
        return customFont
    }
    
    func gilroyMedium(ofSize: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: gilroyMediumName, size: ofSize) else {
            return .systemFont(ofSize: ofSize)
        }
        return customFont
    }
    
    func gilroySemiBoldName(ofSize: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: gilroySemiBoldName, size: ofSize) else {
            return .systemFont(ofSize: ofSize)
        }
        return customFont
    }
    
    private init() {}
    
    static let standart = Fonts()
}
