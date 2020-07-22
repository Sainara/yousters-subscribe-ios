//
//  CreateAgreementViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 17.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SnapKit
import CoreServices

class CreateAgreementViewController: YoustersStackViewController {
    
    let nameField = YoustersTextField(placehldr: "Название документа (необязательно)")
    let fileButton = YoustersButton(text: "Выбрать файл")
    let sendButton = YoustersButton(text: "Добавить")
    
    var fileURL:URL?

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        scrollView.contentInset = .init(top: 40, left: 0, bottom: 0, right: 0)
        scrollView.keyboardDismissMode = .onDrag
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 20
        
        bottomPaddinng = 20
        bottomOffset = -20
        setup()
        
        navigationItem.title = "Добавить договор"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addWidthArrangedSubView(view: nameField)
        addWidthArrangedSubView(view: fileButton, spacing: 50)
        fileButton.addTarget(self, action: #selector(fromFilesButTap), for: .touchUpInside)
        sendButton.isEnabled = false
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottomOffset).constraint
        }
        
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    }
    
    @objc func send() {
        guard let fileURL = fileURL else {return}

        let alert = UIAlertController(style: .loading)
        present(alert, animated: true, completion: nil)
        AgreementService.main.uploadAgreement(title: nameField.text!, location: fileURL) { (result) in
            alert.dismiss(animated: false) {
                if result {
                    App.shared.isNeedUpdateDocs = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    @objc func fromFilesButTap() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
        
    }
}

extension CreateAgreementViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let myURL = urls.first else {return}
        
        print("import result : \(myURL.lastPathComponent)")

        fileButton.setTitle(myURL.lastPathComponent, for: .normal)
        
        fileURL = myURL
        sendButton.isEnabled = true
        
        if nameField.text! == "" {
            nameField.text = myURL.lastPathComponent
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        controller.dismiss(animated: true) {
            //self.fromFilesBut.setTitle("Выбрать из файлов", for: .normal)
        }
    }
}
