//
//  YoustersButton.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 12.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SnapKit
import Haptica

class YoustersButton: UIButton {

    init() {
        super.init(frame: .zero)
    }
    
    convenience init(text:String, fontSize: CGFloat = 17, height:CGFloat = 55, style:YoustersButtonStyle = .basic) {
        self.init()
        setup(text: text, size: fontSize, height: height, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setup(text:String, size:CGFloat, height:CGFloat, style:YoustersButtonStyle) {
        
        setTitle(text, for: .normal)
        
        switch style {
        case .basic:
            setBackgroundColor(color: .bgColor, forState: .normal)
            setBackgroundColor(color: .buttonDisabled, forState: .disabled)
            setBackgroundColor(color: .buttonHighlited, forState: .highlighted)
            titleLabel?.textColor = .white
            isHaptic = true
            hapticType = .impact(.light)
        case .secondary:
            setBackgroundColor(color: .secondaryButtonColor, forState: .normal)
            setBackgroundColor(color: .secondaryButtonDisabled, forState: .disabled)
            setBackgroundColor(color: .secondaryButtonHighlited, forState: .highlighted)
            setTitleColor(.bgColor, for: .normal)
        }
        
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        layer.cornerRadius = 6
        clipsToBounds = true
        titleLabel?.font = Fonts.standart.gilroyMedium(ofSize: size)
    }
    
    enum YoustersButtonStyle {
        case basic, secondary
    }

}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
