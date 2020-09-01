//
//  EnterDocsCodeViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 18.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import MobileCoreServices
import UIKit

class EnterDocsCodeViewController: YoustersViewController {
    
    let phoneField = YoustersTextField(placehldr: "Код", fontSize: 22)
    let button = YoustersButton(text: "Подтвердить", fontSize: 18)
    
    let picker = UIImagePickerController()
    
    unowned var delegate:ReloadProtocol
    
    var videoURL:URL?
    
    init(delegate:ReloadProtocol, code:String) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        print("Added")
        button.isEnabled = false

        App.shared.codeField = phoneField
        
        if let code = App.shared.savedCode {
            phoneField.text = code
            button.isEnabled = true
            App.shared.codeField = nil
            App.shared.savedCode = nil
        }
       
        //App.shared.codeField = phoneField
        
        view.backgroundColor = .white
        
        bottomOffset = -210
        bottomPaddinng = 15
        
        setupView()
        
        picker.delegate = self
        picker.modalPresentationStyle = .popover
        picker.isModalInPopover = true
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.cameraCaptureMode = .video
        picker.cameraDevice = .front
        picker.videoQuality = .typeHigh
        picker.videoMaximumDuration = TimeInterval(integerLiteral: 9)
        
        
        let emj = UILabel(text: "Скажите:\n\"Я согласен с заключением\nдоговора номер \(code)\"", font: Fonts.standart.gilroyMedium(ofSize: 20), textColor: .white, textAlignment: .center, numberOfLines: 0)
        emj.frame = (picker.cameraOverlayView?.frame)!

        picker.cameraOverlayView = emj

        self.present(picker, animated: true, completion: nil)
    }
    
    deinit {
        print("deininted")
        App.shared.codeField = nil
        App.shared.savedCode = nil
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
                
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc private func textFieldDidChange(textField: UITextField){
        button.isEnabled = textField.text!.count == 6
    }
    
    @objc private func tapped() {
        let alert = UIAlertController(style: .loading)
        self.present(alert, animated: true, completion: nil)
        guard let videoURL = videoURL else {return}
        SubscriptionServive.main.validateSubscribe(code: phoneField.text!, videoURL: videoURL) { (result) in
            alert.dismiss(animated: false) {
                if result {
                    self.dismiss(animated: true) {
                        self.delegate.reload()
                    }
                } else {
                    print("error")
                    let alert = UIAlertController(style: .errorMessage, message: "Неверный код")
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

}

extension EnterDocsCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 6
    }
}


extension EnterDocsCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let video = info[.mediaURL] as? URL {
            videoURL = video
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
}


