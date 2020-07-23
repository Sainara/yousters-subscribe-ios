//
//  SberIDAuthViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SberbankSDK

class SberIDAuthViewController: YoustersStackViewController {
    
    let innField = YoustersTextField(placehldr: "ИНН", fontSize: 20)
    let mailField = YoustersTextField(placehldr: "Email", fontSize: 20)
    
    let sberLogin = SBKLoginButton(type: .green)

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        //bottomOffset = -210
        //bottomPaddinng = 15
        
        scrollView.contentInset = .init(top: 20, left: 0, bottom: 90, right: 0)
        //scrollView.keyboardDismissMode = .onDrag
        stackView.spacing = 20.0
        
        addCloseItem()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let label = UILabel(text: "Yousters Subscribe", font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: label, spacing: 5)
        let desc = UILabel(text: "Последний шаг", font: Fonts.standart.gilroyMedium(ofSize: 20), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: desc, spacing: 40)
        
        addWidthArrangedSubView(view: innField)
        innField.delegate = self
        innField.addTarget(self, action: #selector(innFieldDidChange(textField:)), for: .editingChanged)
        innField.textAlignment = .left
        innField.keyboardType = .numberPad
        
        addWidthArrangedSubView(view: mailField)
        mailField.addTarget(self, action: #selector(emailFieldDidChange(textField:)), for: .editingChanged)
        mailField.textAlignment = .left
        mailField.keyboardType = .emailAddress
        mailField.textContentType = .emailAddress
        mailField.autocapitalizationType = .none
        
        sberLogin.isEnabled = false
        
        sberLogin.setup(text: .continue_)
        sberLogin.layer.opacity = 0.6
        sberLogin.addTarget(self, action: #selector(loginSber), for: .touchUpInside)
        addWidthArrangedSubView(view: sberLogin, spacing: 10)
        
        let info = UILabel(text: "Это безопасно и удобно. Ваши данные защищены шифрованием.", font: Fonts.standart.gilroyRegular(ofSize: 15), textColor: .blackTransp, textAlignment: .center, numberOfLines: 0)
        addWidthArrangedSubView(view: info)
    }
    

    @objc private func innFieldDidChange(textField: UITextField){
        checkAllData()
    }
    
    @objc private func emailFieldDidChange(textField: UITextField){
        checkAllData()
    }
    
    @objc private func loginSber(){
        
        let alert = UIAlertController(style: .loading)
        self.present(alert, animated: true, completion: nil)
        
        SberService.main.initAuth { (requestData) in
            alert.dismiss(animated: false) {
                if let requestData = requestData {
                    // Параметры для поддержки PKCE
                    let verifier = SBKUtils.createVerifier()
                    let challenge = SBKUtils.createChallenge(verifier)
                    
                    let request = SBKAuthRequest()
                    request.clientId = requestData.clientID
                    request.nonce = requestData.nonce
                    request.scope = requestData.scope //Перечесление scope через пробел
                    request.state = requestData.state
                    request.redirectUri = "you-scribe://sberidauth"
                    request.codeChallenge = challenge //Необязательный параметр
                    request.codeChallengeMethod = SBKUtilsCodeChallengeMethod //Необязательный параметр
                     
                    // Запуск аутентификации
                    SBKAuthManager.auth(withSberId: request)
                }
            }
        }
        
    }
    
    private func checkAllData() {
        if Validations.checkEmail(email: mailField.text!),
            Validations.checkINN(inn: innField.text!)
        {
            sberLogin.isEnabled = true
            sberLogin.layer.opacity = 1
        } else {
            sberLogin.isEnabled = false
            sberLogin.layer.opacity = 0.6
        }
    }

}

extension SberIDAuthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
}
