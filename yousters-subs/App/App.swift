//
//  App.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation
import UIKit

class App {
    private init() {
        token = SaveRestoreProvider.shared.restoreToken()
        currentUser = SaveRestoreProvider.shared.restoreUser()
    }
    
    static let shared = App()
    
    var token:String? {
        didSet {
            SaveRestoreProvider.shared.saveToken(token: token)
        }
    }
    
    var currentUser:AbstractUser? {
        didSet {
            SaveRestoreProvider.shared.saveUser(user: currentUser)
        }
    }
    
    func logOut(topController:UIViewController? = nil) {
        PushService.main.removeToken()
        
        token = nil
        currentUser = nil
        
        CodeEntity.shared.code = nil
        
        let vc = RouteProvider.shared.firstEnterView()
        RouteProvider.switchRootViewController(rootViewController: vc, animated: true, completion: nil)
        
    }
    
    weak var codeField:UITextField?
    var savedCode:String?
    
    var isNeedUpdateDocs = false
    var isNeedUpdateProfile = false
}
