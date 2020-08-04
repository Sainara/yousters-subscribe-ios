//
//  SelectPhizAuthViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
//import SberbankSDK

//class SelectPhizAuthViewController: YoustersStackViewController {
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        
//        view.backgroundColor = .white
//        
//        //bottomOffset = -210
//        //bottomPaddinng = 15
//        
//        scrollView.contentInset = .init(top: view.frame.height/3, left: 0, bottom: 90, right: 0)
//        stackView.distribution = .equalSpacing
//        //scrollView.keyboardDismissMode = .onDrag
//        stackView.spacing = 5
//        
//        addCloseItem(addFromSuper: true)
//        setup()
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    private func setup() {
//
//        let sberLogin = SBKLoginButton(type: .green)
//        sberLogin.setup(text: .login)
//        sberLogin.addTarget(self, action: #selector(loginSber), for: .touchUpInside)
//        addWidthArrangedSubView(view: sberLogin)
//        
//        addWidthArrangedSubView(view: UILabel(text: " - или - ", font: Fonts.standart.gilroyRegular(ofSize: 15), textColor: .blackTransp, textAlignment: .center, numberOfLines: 0))
//        
//        let ipOrOOO = YoustersButton(text: "Ввести данные вручную")
//        ipOrOOO.addTarget(self, action: #selector(phizClick), for: .touchUpInside)
//        addWidthArrangedSubView(view: ipOrOOO)
//    }
//    
//    @objc private func phizClick() {
//        let phizNext = EnterValidateDataViewController()
//        phizNext.modalPresentationStyle = .popover
//        self.present(phizNext, animated: true, completion: nil)
//    }
//    
//    @objc private func loginSber() {
//        let sberNext = SberIDAuthViewController()
//        sberNext.modalPresentationStyle = .popover
//        self.present(sberNext, animated: true, completion: nil)
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
