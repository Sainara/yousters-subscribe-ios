//
//  EnterCodeOrFaceID.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 17.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import LocalAuthentication
import Haptica

class EnterCodeOrFaceID: YoustersViewController {
    
    var context = LAContext()
    
    var enteredCode = "" {
        willSet {
            codeView.setEntered(code: newValue)
        }
    }
    
    let codeView = CodeView()
    
    var isInProcess = false
    
    var target:InitTypes
    
    init(target:InitTypes) {
        self.target = target
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        switch target {
        case .enterCode:
            if context.biometryType != .none {
                callBiometry()
            }
        case .createCode:
            break
        case .repeatCode:
            break
        }
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        guard let user = App.shared.currentUser else {
            App.shared.logOut()
            return
        }
        
        var title = ""
        
        switch target {
        case .enterCode:
            title = user.name ?? user.phone
        case .createCode:
            title = "Придумайте код для входа"
        case .repeatCode:
            title = "Повторите код"
        }
        
        let userName = UILabel(text: title.uppercased(), font: Fonts.standart.gilroySemiBoldName(ofSize: 17), textColor: .bgColor, textAlignment: .center, numberOfLines: 0)
        userName.minimumScaleFactor = 0.5
        view.addSubview(userName)
        userName.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(180)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //make.height.equalTo(45)
        }
        
        
        view.addSubview(codeView)
        codeView.snp.makeConstraints { (make) in
            make.top.equalTo(userName.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(35)
        }
        
        let padView = CodePadView(delegate: self, isInCreate: target != .enterCode)
        view.addSubview(padView)
        padView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func callBiometry() {

        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

            let reason = "Войти в приложение"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                if success {
                    DispatchQueue.main.async {
                        RouteProvider.switchRootViewController(rootViewController: MainTabBarViewController(), animated: true, completion: nil)
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
        }
    }
    
    private func resetCode() {
        enteredCode = ""
        Haptic.play([.haptic(.notification(.error))])
    }
    
    enum InitTypes {
        case enterCode, createCode, repeatCode
    }

}

extension EnterCodeOrFaceID: EnterCodePadDelegate {
    func digitClicked(digit: Int) {
        if enteredCode.count < 4 {
            enteredCode += String(digit)
        }
        
        if enteredCode.count == 4 && !isInProcess {
            let seconds = 0.7
            isInProcess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
                if self != nil {
                    switch self!.target {
                    case .enterCode:
                        if self!.enteredCode == CodeEntity.shared.code! {
                            var mainTabBar:UIViewController!
                            
                            if let savedVC = CodeEntity.shared.savedViewController {
                                mainTabBar = savedVC
                            } else {
                                mainTabBar = MainTabBarViewController()
                            }
                            
                            RouteProvider.switchRootViewController(rootViewController: mainTabBar, animated: true) {
                                DeepLinkManager.standart.checkDeepLink(viewController: mainTabBar)
                            }
                        }  else {
                            self!.isInProcess = false
                            self!.resetCode()
                        }
                    case .createCode:
                        CodeEntity.shared.code = self!.enteredCode
                        let repeatView = EnterCodeOrFaceID(target: .repeatCode)
                        
                        self!.present(repeatView, animated: true, completion: nil)
                    case .repeatCode:
                        if self!.enteredCode == CodeEntity.shared.code! {
                            CodeEntity.shared.setCode()
                            RouteProvider.switchRootViewController(rootViewController: MainTabBarViewController(), animated: true, completion: nil)
                        } else {
                            self!.isInProcess = false
                            self!.resetCode()
                        }
                    }
                }
            }
        }
    }
    
    func removeCliced() {
        enteredCode = String(enteredCode.dropLast())
    }
    
    func biometryClicked() {
        callBiometry()
    }
}
