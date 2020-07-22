//
//  YoustersAlert.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

extension UIAlertController {
    
    convenience init(style: UIAlertController.AlertType, title:String? = "", message:String? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        switch style {
        case .loading:
            makeLoader()
        case .errorMessage:
            self.title = "Ошибка"
            makeMessage()
        case .message:
            makeMessage()
        }
        
    }
    
    private func makeLoader() {
        
        let loadingIndicator = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .bgColor)
        loadingIndicator.startAnimating()
        
        view.snp.makeConstraints { (make) in
            make.height.equalTo(70)
            make.width.equalTo(100)
        }
        view.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
    private func makeMessage() {
        let close = UIButton(image: UIImage(imageLiteralResourceName: "close"), tintColor: .bgColor, target: self, action: #selector(hide))
        view.addSubview(close)
        close.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.trailing.equalToSuperview().offset(-5)
        }
        let titleAttributes = [NSAttributedString.Key.font: Fonts.standart.gilroySemiBoldName(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleString = NSAttributedString(string: title ?? "", attributes: titleAttributes)
        let messageAttributes = [NSAttributedString.Key.font: Fonts.standart.gilroyMedium(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black]
        let messageString = NSAttributedString(string: message ?? "", attributes: messageAttributes)
        
        setValue(titleString, forKey: "attributedTitle")
        setValue(messageString, forKey: "attributedMessage")
        
    
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        //view.superview?.subviews[0].isUserInteractionEnabled = true
        //view.superview?.subviews[0].addGestureRecognizer(tap)
    }
    
    @objc private func hide() {
        dismiss(animated: true, completion: nil)
    }
    
    enum AlertType {
        case loading, message, errorMessage
    }
}
