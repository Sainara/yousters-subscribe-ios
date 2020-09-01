//
//  CodeEntity.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 18.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation
import SwiftDate

class CodeEntity {
    
    private init() {
        if let code = SaveRestoreProvider.shared.restoreCode() {
            self.code = code
            isSet = true
        } else {
            isSet = false
        }
    }
    
    static let shared = CodeEntity()
    
    var tryCounter = 0
    
    var code:String?
    var isSet:Bool
    
    var enterBackgroundTime:Date?
    
    func setCode() {
        SaveRestoreProvider.shared.saveCode()
    }
    
    func setEnterBackgroundTime() {
        enterBackgroundTime = Date()
        print(enterBackgroundTime)
    }
    
    func isNeedEnterCodeAndPresent() {
        print("isNeedEnterCodeAndPresent = \(enterBackgroundTime)")
        guard let time = enterBackgroundTime else {
            return
        }
        if Date() > time + 20.seconds {
            RouteProvider.switchRootViewController(rootViewController: EnterCodeOrFaceID(target: .enterCode), animated: false, completion: nil)
            enterBackgroundTime = nil
        }
    }
    
}
