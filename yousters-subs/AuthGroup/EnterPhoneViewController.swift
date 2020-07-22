//
//  EnterPhoneViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import LBTATools
import SnapKit
import PhoneNumberKit

class EnterPhoneViewController: YoustersViewController {
    
    let phoneField = YoustersPhoneNumberTextField(placehldr: "Номер телефона", fontSize: 22)
    let button = YoustersButton(text: "Продолжить", fontSize: 18)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        
        bottomOffset = -210
        bottomPaddinng = 15
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let label = UILabel(text: "Yousters Subscribe", font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        
        view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(55)
        }
        
        let desc = UILabel(text: "Подпись в один клик", font: Fonts.standart.gilroyMedium(ofSize: 20), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        view.addSubview(desc)
        
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(35)
        }
        
        
        button.backgroundColor = .mainColor
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            self.bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottomOffset).constraint
        }
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        view.addSubview(phoneField)
        //phoneField.keyboardType = .phonePad
        
        phoneField.snp.makeConstraints { (make) in
            make.bottom.equalTo(button.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(35)
        }
        
        phoneField.delegate = self
        phoneField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
    }
    
    @objc private func tapped() {
        
        let alert = UIAlertController(style: .loading)
        self.present(alert, animated: true, completion: nil)
        
        AuthService.main.sendPhone(phoneNumber: phoneField.text!) { (result) in
            alert.dismiss(animated: false) {
                if result {
                    let vc = EnterCodeViewController(phone: self.phoneField.text!)
                    vc.modalPresentationStyle = .popover
                    self.present(vc, animated: true, completion: nil)
                } else {
                    print("error")
                    let alert = UIAlertController(style: .errorMessage)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc private func textFieldDidChange(textField: UITextField){
        button.isEnabled = PhoneNumberKit().isValidPhoneNumber(textField.text!, withRegion: "RU")
    }

}

extension EnterPhoneViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
//        var maxLength = 11
//        if let first = text.first {
//            if first == "+" {
//                maxLength = 12
//            }
//        }
        return newLength <= 16
    }
}
