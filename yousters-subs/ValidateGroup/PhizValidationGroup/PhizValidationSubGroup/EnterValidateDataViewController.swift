//
//  EnterValidateDataViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import MobileCoreServices

class EnterValidateDataViewController: YoustersStackViewController {
    
    let mailField = YoustersTextField(placehldr: "Email", fontSize: 20)
    
    let picker = UIImagePickerController()
    
    let addMainPassportPageButton = YoustersButton(text: "Сфотографировать", fontSize: 18)
    let addSecondPassportPageButton = YoustersButton(text: "Сфотографировать", fontSize: 18)
    let addVideoButton = YoustersButton(text: "Записать", fontSize: 18)
    
    let sendButton = YoustersButton(text: "Отправить", fontSize: 18)
    
    var mainPassportPageURL:URL?
    var secondPassportPageURL:URL?
    var videoURL:URL?

    var picking:WhatPicking!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        //bottomOffset = -210
        //bottomPaddinng = 15
        
        scrollView.contentInset = .init(top: 20, left: 0, bottom: 90, right: 0)
        scrollView.keyboardDismissMode = .onDrag
        stackView.spacing = 20.0
        
        addCloseItem()
        setupView()
        setupPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPicker() {
        #if targetEnvironment(simulator)
          // your simulator code
        #else
          picker.sourceType = .camera
        #endif
        
        picker.delegate = self
        picker.modalPresentationStyle = .popover
    }
    
    private func setupView() {
        
        let label = UILabel(text: "Yousters Subscribe", font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: label, spacing: 5)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        let desc = UILabel(text: "Последний шаг", font: Fonts.standart.gilroyMedium(ofSize: 20), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: desc, spacing: 40)
        
        addWidthArrangedSubView(view: mailField)
        mailField.addTarget(self, action: #selector(emailFieldDidChange(textField:)), for: .editingChanged)
        mailField.textAlignment = .left
        mailField.keyboardType = .emailAddress
        mailField.textContentType = .emailAddress
        mailField.autocapitalizationType = .none
        
        
        let addMainPassportPageLabel = UILabel(text: "Страница паспорта с фотографией", font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: addMainPassportPageLabel, spacing: 5)
        
        
        addWidthArrangedSubView(view: addMainPassportPageButton)
        addMainPassportPageButton.addTarget(self, action: #selector(captureMain), for: .touchUpInside)

        
        let addSecondPassportPageLabel = UILabel(text: "Страница паспорта с регистрацией", font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: addSecondPassportPageLabel, spacing: 5)
        

        addWidthArrangedSubView(view: addSecondPassportPageButton)
        addSecondPassportPageButton.addTarget(self, action: #selector(captureSecond), for: .touchUpInside)
        
        let addVideoLabel = UILabel(text: "Запишите селфи-видео с паспортом в котором вы произносите ваш номер телефона. Должно быть видно вас и фото на паспорте.", font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: addVideoLabel, spacing: 5)
        
        
        addWidthArrangedSubView(view: addVideoButton)
        addVideoButton.addTarget(self, action: #selector(captureVideo), for: .touchUpInside)
        
        
        sendButton.backgroundColor = .mainColor
        view.addSubview(sendButton)
        
        sendButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        sendButton.isEnabled = false
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        
    }
    
    
    @objc private func send() {
        
        let data = DocsToValidateData(email: mailField.text!,
                                      main: mainPassportPageURL!,
                                      second: secondPassportPageURL!,
                                      video: videoURL!)
        let alert = UIAlertController(style: .loading)
        self.present(alert, animated: true, completion: nil)
        ValidateDocsService.main.sendDocs(data: data) { (result) in
            alert.dismiss(animated: false) {
                if result {
                    self.dismiss(animated: true, completion: nil)
                    if let selectVC = self.presentingViewController as? SelectOrgTypeViewController {
                        selectVC.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("error")
                    let alert = UIAlertController(style: .errorMessage)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func additionSetupAndPresent() {
        
        switch picking {
        case .main, .secondary:
            picker.mediaTypes = [kUTTypeImage as String]
            picker.cameraCaptureMode = .photo
            picker.cameraDevice = .rear
        case .video:
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.cameraCaptureMode = .video
            picker.cameraDevice = .front
            picker.videoQuality = .typeHigh
            picker.videoMaximumDuration = TimeInterval(integerLiteral: 9)
        case .none:
            return
        }
        
        present(picker, animated: true, completion: nil)
    }
   
    @objc private func captureMain() {
        picking = .main
        additionSetupAndPresent()
        
    }
    @objc private func captureSecond() {
        picking = .secondary
        additionSetupAndPresent()
        
    }
    @objc private func captureVideo() {
        picking = .video
        additionSetupAndPresent()
    }
    
    @objc private func innFieldDidChange(textField: UITextField){
        checkAllData()
    }
    
    @objc private func emailFieldDidChange(textField: UITextField){
        checkAllData()
    }
    
    private func checkAllData() {
        if Validations.checkEmail(email: mailField.text!),
            mainPassportPageURL != nil,
            secondPassportPageURL != nil,
            videoURL != nil
        {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
   
    enum WhatPicking {
        case main, secondary, video
    }
}

extension EnterValidateDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        switch picking {
        case .main:
            if let pickedImage = info[.originalImage] as? UIImage {
                getImageURL(image: pickedImage) { (url) in
                    self.mainPassportPageURL = url
                    self.addMainPassportPageButton.setTitle("Готово", for: .normal)
                }
            }
        case .secondary:
            if let pickedImage = info[.originalImage] as? UIImage {
                getImageURL(image: pickedImage) { (url) in
                    self.secondPassportPageURL = url
                    self.addSecondPassportPageButton.setTitle("Готово", for: .normal)
                }
            }
        case .video:
            if let video = info[.mediaURL] as? URL {
                videoURL = video
                addVideoButton.setTitle("Готово", for: .normal)
            }
        case .none:
            break
        }
        checkAllData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getImageURL(image:UIImage, complition: @escaping (URL)->Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName + ".jpg")
            
            let data = image.jpegData(compressionQuality: 0.8)! as NSData
            data.write(toFile: localPath, atomically: true)
            let photoURL = URL(fileURLWithPath: localPath)
            print(photoURL)
            
            DispatchQueue.main.async {
                complition(photoURL)
            }
        }
    }
}

extension EnterValidateDataViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
}
