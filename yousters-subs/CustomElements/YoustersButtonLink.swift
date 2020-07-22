//
//  YoustersButtonLink.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 17.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class YoustersButtonLink: UIButton {
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var link:String
    var title:String
    
    init(link:String, fontSize:CGFloat = 17, title:String? = nil, isUnderLined:Bool = false) {
        self.link = link
        self.title = link
        if let title = title {
            self.title = title
        }
        super.init(frame: .zero)
        setup(fontSize: fontSize, isUnderLined: isUnderLined)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(fontSize:CGFloat, isUnderLined:Bool) {
        isUserInteractionEnabled = true
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        longPressGR.minimumPressDuration = 0.4 // how long before menu pops up
        addGestureRecognizer(longPressGR)
        
        //
        if isUnderLined {
            setAttributedTitle(NSAttributedString(string: title, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        } else {
            setTitle(title, for: .normal)
        }
        setTitleColor(.bgColor, for: .normal)
        setTitleColor(.blackTransp, for: .highlighted)
        contentHorizontalAlignment = .center
        titleLabel?.font = Fonts.standart.gilroyMedium(ofSize: fontSize)
        addTarget(self, action: #selector(openDoc), for: .touchUpInside)
        
        snp.makeConstraints { (make) in
            make.height.equalTo(20)
        }
    }
    
    @objc func longPressHandler(sender: UILongPressGestureRecognizer) {
        
        guard sender.state == .began,
            let senderView = sender.view,
            let superView = sender.view?.superview
            else { return }
        
        // Make responsiveView the window's first responder
        senderView.becomeFirstResponder()
        
        // Set up the shared UIMenuController
        let saveMenuItem = UIMenuItem(title: "Скопировать", action: #selector(copyTapped))
        UIMenuController.shared.menuItems = [saveMenuItem]
        
        // Tell the menu controller the first responder's frame and its super view
        UIMenuController.shared.setTargetRect(senderView.frame, in: superView)
        
        // Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
        print("!!!!!!!")
    }
    
    @objc func copyTapped() {
        print("save tapped")
        
        UIPasteboard.general.string = link
        resignFirstResponder()
    }
    
    @objc func openDoc() {
        guard var url = URL(string: link) else {return}
        
        if !(["http", "https"].contains(url.scheme?.lowercased())) {
            let appendedLink = "http://".appending(link)

            url = URL(string: appendedLink)!
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
