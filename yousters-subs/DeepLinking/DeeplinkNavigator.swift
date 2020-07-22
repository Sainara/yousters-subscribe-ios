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
    
    func proceedToDeeplink(_ type: DeeplinkType, viewController:UIViewController?) {
        
        func addToAddedIfNeed(agreement:Agreement) {
            AgreementService.main.addAgreementToAdded(uid: agreement.uid) { (res) in
                print("is added \(agreement.uid) to added - \(res)")
            }
        }
        
        func present(uid:String, viewController:UIViewController?) {
            let alert = UIAlertController(style: .loading)
            viewController?.present(alert, animated: true, completion: nil)
            AgreementService.main.getAgreement(uid: uid) { (agreement) in
                alert.dismiss(animated: false) {
                    if let agreement = agreement {
                        let agreementPage = AgreementPageViewController(agreemant: agreement, type: .deepLink)
                        agreementPage.modalPresentationStyle = .popover
                        
                        viewController?.present(agreementPage, animated: true, completion: nil)
                        
                        addToAddedIfNeed(agreement: agreement)
                    }
                }
            }
        }
        
        switch type {
        case .agreement(uid: let uid):
            viewController?.presentedViewController?.dismiss(animated: false, completion: {
                present(uid: uid, viewController: viewController)
                return
            })
            present(uid: uid, viewController: viewController)
        }
    }
}
