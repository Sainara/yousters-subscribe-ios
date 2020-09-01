//
//  NonPhizValidationViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import MobileCoreServices

class NonPhizValidationViewController: YoustersStackViewController {

    let innField = YoustersTextField(placehldr: "ИНН", fontSize: 20)
    let mailField = YoustersTextField(placehldr: "Email", fontSize: 20)
    let addVideoButton = YoustersButton(text: "Записать", fontSize: 18)
    
    let picker = UIImagePickerController()

    
    let sendButton = YoustersButton(text: "Оплатил", fontSize: 18)
    let linkToPDF = YoustersButton(text: "Счет на оплату", fontSize: 18, style: .secondary)
        
    var videoURL:URL?

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        scrollView.contentInset = .init(top: 20, left: 0, bottom: 90, right: 0)
        scrollView.keyboardDismissMode = .onDrag
        stackView.spacing = 20.0
        
        setupPicker()
        addCloseItem()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPicker() {
        picker.delegate = self
        picker.modalPresentationStyle = .popover
        picker.isModalInPopover = true
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.cameraCaptureMode = .video
        picker.cameraDevice = .front
        picker.videoQuality = .typeHigh
        picker.videoMaximumDuration = TimeInterval(integerLiteral: 9)
    }
    
    private func setupView() {
        
        let label = UILabel(text: "Yousters Subscribe", font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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
        
        let addVideoLabel = UILabel(text: "Запишите селфи-видео в котором вы произносите ваш номер телефона.", font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: addVideoLabel, spacing: 5)
        
        addWidthArrangedSubView(view: addVideoButton)
        addVideoButton.addTarget(self, action: #selector(captureVideo), for: .touchUpInside)
        
        
        let info = UILabel(text: "Для идентификации необходимо перевести 1₽ с вашего расчетного счета, ссылка на счет на оплату появится, после ввода ИНН, Email и селфи-видео, так же ссылка будет доступна на экране профиля после нажатия кнопки \"Оплатил\"", font: Fonts.standart.gilroyRegular(ofSize: 15), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: info)
        
        linkToPDF.isEnabled = false
        linkToPDF.layer.opacity = 0.6
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
    
    @objc private func captureVideo() {
        self.present(picker, animated: true, completion: nil)
    }

    @objc private func innFieldDidChange(textField: UITextField){
        checkAllData()
    }
    
    @objc private func emailFieldDidChange(textField: UITextField){
        checkAllData()
    }
    
    private func checkAllData() {
        if Validations.checkEmail(email: mailField.text!),
            Validations.checkINN(inn: innField.text!),
            videoURL != nil
        {
            linkToPDF.layer.opacity = 1
            linkToPDF.isEnabled = true
            sendButton.isEnabled = true
            
        } else {
            sendButton.isEnabled = false
            linkToPDF.layer.opacity = 0.6
            linkToPDF.isEnabled = false
        }
    }
    
    @objc private func openPDF() {
        guard let token = App.shared.token else {return}
        let link = URLs.requisites(inn: innField.text!, email: mailField.text!, token: token)
        guard var url = URL(string: link) else {return}
        
        if !(["http", "https"].contains(url.scheme?.lowercased())) {
            let appendedLink = "http://".appending(link)

            url = URL(string: appendedLink)!
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func send() {
        let data = NonPhizData(inn: innField.text!, email: mailField.text!, video: videoURL!)
        let alert = UIAlertController(style: .loading)
        self.present(alert, animated: true, completion: nil)
        ValidateDocsService.main.sendNonPhizToValidation(data: data) { (result) in
            alert.dismiss(animated: false) {
                if result {
                    self.dismiss(animated: true, completion: nil)
                    if let selectVC = self.presentingViewController as? SelectOrgTypeViewController {
                        selectVC.dismiss(animated: true, completion: nil)
                    }
//                    print(result)
//                    let vc = EnterCodeOrFaceID(target: .createCode)
//                    RouteProvider.switchRootViewController(rootViewController: vc, animated: true, completion: nil)
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

extension NonPhizValidationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        if let video = info[.mediaURL] as? URL {
            videoURL = video
            addVideoButton.setTitle("Готово", for: .normal)
        } else {
            videoURL = nil
        }
        checkAllData()
        picker.dismiss(animated: true, completion: nil)
    }
}
