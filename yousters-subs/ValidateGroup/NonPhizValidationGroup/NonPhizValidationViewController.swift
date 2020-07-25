//
//  NonPhizValidationViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class NonPhizValidationViewController: YoustersStackViewController {

    let innField = YoustersTextField(placehldr: "ИНН", fontSize: 20)
    let mailField = YoustersTextField(placehldr: "Email", fontSize: 20)
    
    let sendButton = YoustersButton(text: "Оплатил", fontSize: 18)
    let linkToPDF = YoustersButtonLink(link: "", title: "Мы тут", isUnderLined: true)

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
        
        let info = UILabel(text: "Для идентификации необходимо перевести 1₽ с вашего расчетного счета в банке по этим реквизитам", font: Fonts.standart.gilroyRegular(ofSize: 15), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        
        addWidthArrangedSubView(view: info, spacing: 5)
        
        linkToPDF.contentHorizontalAlignment = .leading
        
        linkToPDF.isEnabled = false
        linkToPDF.layer.opacity = 0.5
        addWidthArrangedSubView(view: linkToPDF)
        
        view.addSubview(sendButton)
        
        sendButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        sendButton.isEnabled = false
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
       
    }
    

    @objc private func innFieldDidChange(textField: UITextField){
        checkAllData()
    }
    
    @objc private func emailFieldDidChange(textField: UITextField){
        checkAllData()
    }
    
    private func checkAllData() {
        if Validations.checkEmail(email: mailField.text!),
            Validations.checkINN(inn: innField.text!)
        {
            linkToPDF.layer.opacity = 1
            linkToPDF.isEnabled = true
            sendButton.isEnabled = true
            
            guard let token = App.shared.token else {return}
            linkToPDF.link = URLs.requisites(inn: innField.text!, email: mailField.text!, token: token)
            print(linkToPDF.link)
            
        } else {
            sendButton.isEnabled = false
            linkToPDF.layer.opacity = 0.5
            linkToPDF.isEnabled = false
        }
    }
    
    @objc private func send() {
        let data = NonPhizData(inn: innField.text!, email: mailField.text!)
        let alert = UIAlertController(style: .loading)
        self.present(alert, animated: true, completion: nil)
        ValidateDocsService.main.sendNonPhizToValidation(data: data) { (result) in
            alert.dismiss(animated: false) {
                if result {
                    print(result)
                    let vc = MainTabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    print("error")
                    let alert = UIAlertController(style: .errorMessage)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension NonPhizValidationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
}
