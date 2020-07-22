//
//  YoustersPhoneNumberTextField.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 16.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import PhoneNumberKit
import UIKit

class YoustersPhoneNumberTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "RU"
        }
        set {} // exists for backward compatibility
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    convenience init(placehldr:String, fontSize: CGFloat = 17) {
        self.init()
        placeholder = placehldr
        setup(size: fontSize)
        withPrefix = true
        withExamplePlaceholder = true
        //withFlag = true
        //phoneNumberKit.metadata(for: "RU")?.mobile?.exampleNumber
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(size:CGFloat) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blackTransp, NSAttributedString.Key.font: Fonts.standart.gilroyRegular(ofSize: size)])
        
        self.textColor = .bgColor
        self.tintColor = .bgColor
        self.font = Fonts.standart.gilroyMedium(ofSize: size)
    }
}
