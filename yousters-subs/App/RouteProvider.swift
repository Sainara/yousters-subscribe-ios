//
//  RouteProvider.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation
import UIKit

class RouteProvider {
    private init() {}
    
    static let shared = RouteProvider()
    
    func initViewController() -> UIViewController {
        guard SaveRestoreProvider.shared.restoreToken() != nil else {
            return EnterPhoneViewController()
        }
        guard let user = SaveRestoreProvider.shared.restoreUser() else {
            return EnterPhoneViewController()
        }
        if user.isValid || user.isOnValidation {
            return MainTabBarViewController()
        }
        return SelectOrgTypeViewController() // EnterVal...
        //EnterPhoneViewController()
    }
    
    func enteredCode(isValidOrOnIt:Bool) -> UIViewController {
        if isValidOrOnIt {
            return MainTabBarViewController()
        }
        return SelectOrgTypeViewController() // EnterVal...
    }
    
    func firstEnterView() -> UIViewController {
        let vc = EnterPhoneViewController()
        vc.modalPresentationStyle = .fullScreen
        
        return vc
    }
}

