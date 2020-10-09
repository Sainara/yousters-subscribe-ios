//
//  EnterCodeViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class EnterCodeViewController: YoustersViewController {
    
    let phoneField = YoustersTextField(placehldr: "Код", fontSize: 22)
    let button = YoustersButton(text: "Авторизоваться", fontSize: 18)
    
    var phone:String

    init(phone:String) {
        self.phone = phone
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
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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
        
        view.addSubview(phoneField)
        phoneField.textAlignment = .center
        phoneField.keyboardType = .numberPad
        
        phoneField.snp.makeConstraints { (make) in
            make.bottom.equalTo(button.snp.top).offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(35)
        }
        
        phoneField.delegate = self
        phoneField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
//        let info = UILabel(text: "На номер \(phone) была отправлена СМС с кодом", font: Fonts.standart.gilroyRegular(ofSize: 17), textColor: .bgColor, textAlignment: .center, numberOfLines: 0)
//        
//        view.addSubview(info)
//        
//        info.snp.makeConstraints { (make) in
//            make.bottom.equalTo(phoneField.snp.top).offset(-20)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//        }
        button.isEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            if let code = App.shared.savedCode {
//                self.phoneField.text = code
//                self.button.isEnabled = true
//                App.shared.savedCode = nil
//                self.tapped()
//            }
//        }
        //App.shared.codeField = phoneField
        
        
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func textFieldDidChange(textField: UITextField){
        if textField.text!.count == 6 {
            button.isEnabled = true
            tapped()
        }
    }
    
    @objc private func tapped() {
        let alert = UIAlertController(style: .loading)
        self.present(alert, animated: true, completion: nil)
        AuthService.main.sendCode(verificationCode: phoneField.text!) { (result, isValidOrOnIt, error) in
            alert.dismiss(animated: false) {
                if result {
                    let vc = EnterCodeOrFaceID(target: .createCode)
                    //let vc = RouteProvider.shared.enteredCode(isValidOrOnIt: isValidOrOnIt)
                    RouteProvider.switchRootViewController(rootViewController: vc, animated: true, completion: nil)
                } else {
                    PrimaryError.showAlertWithError(vc: self, error: error)
                }
            }
        }
    }

}

extension EnterCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 6
    }
}

