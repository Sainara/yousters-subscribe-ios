//
//  DeeplinkNavigator.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 25.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class DeeplinkNavigator {
    static let shared = DeeplinkNavigator()
    private init() { }
    
    func proceedToDeeplink(_ type: DeeplinkType, viewController:UIViewController?) -> Bool {
        
        func present(uid:String, viewController:UIViewController?) {
            let alert = UIAlertController(style: .loading)
            viewController?.present(alert, animated: true, completion: nil)
            AgreementService.main.getAgreement(uid: uid) { (agreement) in
                alert.dismiss(animated: false) {
                    if let agreement = agreement {
                        let agreementPage = AgreementPageViewController(agreemant: agreement, type: .deepLink)
                        agreementPage.modalPresentationStyle = .popover
                        
                        viewController?.present(agreementPage, animated: true, completion: nil)
                    }
                }
            }
        }
        
        switch type {
        case .agreement(uid: let uid):
            if let tabBar = viewController as? MainTabBarViewController {
                if let agrPage = tabBar.presentedViewController as? AgreementPageViewController {
                    agrPage.dismiss(animated: false, completion: {
                        present(uid: uid, viewController: viewController)
                        
                    })
                    return true
                }
                present(uid: uid, viewController: viewController)
                return true
   
            }
            return false
        case .profileActivation:
            if let tabBar = viewController as? MainTabBarViewController {
                tabBar.selectedIndex = 2
                return true
            }
            return false
        case .dialog(uid: let uid):
            if let tabBar = viewController as? MainTabBarViewController {
                tabBar.selectedIndex = 1
                if let dialogsNC = tabBar.selectedViewController as? YoustersNavigationController {
                    dialogsNC.popToRootViewController(animated: false)
                    if let dialogsVC = dialogsNC.topViewController as? MainDialogsViewController {
                        if !dialogsVC.showDialog(with: uid) {
                            dialogsVC.setNeedShow(with: uid)
                        }
                        return true
                    }
                }
            }
            return false
        }
        
    }
}
