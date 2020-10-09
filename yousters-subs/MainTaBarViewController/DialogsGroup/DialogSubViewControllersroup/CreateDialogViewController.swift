//
//  CreateDialogViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 03.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SnapKit
import CoreServices

class CreateDialogViewController: YoustersStackViewController {
    
    let nameField = YoustersTextField(placehldr: "Название диалога (необязательно)")
    let sendButton = YoustersButton(text: "Начать диалог")
    

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
        
        navigationItem.title = "Создать диалог"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addWidthArrangedSubView(view: nameField)
        
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottomOffset).constraint
        }
        
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    }
    
    @objc func send() {

        let alert = UIAlertController(style: .loading)
        present(alert, animated: true, completion: nil)
        DialogsService.main.createDialog(title: nameField.text!) { (result, error) in
            alert.dismiss(animated: false) {
                print(result)
                print(error)
                if result {
                    App.shared.isNeedUpdateDialogs = true
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let error = UIAlertController(style: .errorMessage, title: error, message: nil)
                    self.present(error, animated: true, completion: nil)
                }
            }
        }
    }
    
}

