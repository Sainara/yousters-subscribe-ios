//
//  ActionExecutor.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 05.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class ActionExecutor {
    static let shared = ActionExecutor()
    private init() { }
    
    func executeAction(_ type: ActionType, viewController:UIViewController?) {
        
        switch type {
        case .enterCode(let code):
            App.shared.codeField?.insertText(code)
            App.shared.codeField = nil
            App.shared.savedCode = code
        case .reloadAgreements:
            if let tabBar = viewController as? MainTabBarViewController {
                tabBar.buildTabs()
            }
        case .reloadMe:
            if let tabBar = viewController as? MainTabBarViewController {
                if let profileViewNavRaw = tabBar.viewControllers?[2],
                    let profileViewNav = profileViewNavRaw as? UINavigationController {
                    profileViewNav.popToRootViewController(animated: false)
                    if let profileViewRaw = profileViewNav.topViewController,
                        let profileView = profileViewRaw as? ProfileViewController {
                        profileView.reload()
                        print("profileView.reload()")
                    }
                }
            }
        }
    }
}
