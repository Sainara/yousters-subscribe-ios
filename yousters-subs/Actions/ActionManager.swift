//
//  ActionManager.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 05.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//
import UIKit

class ActionManager {
    private init() {}
    static let standart = ActionManager()
    
    
    private var actionType: ActionType?
    // check existing deepling and perform action
    func checkAction(viewController:UIViewController?) {
        //print(deeplinkType)
        guard let actionType = actionType else {
            return
        }
        
        ActionExecutor.shared.executeAction(actionType, viewController: viewController)
        // reset deeplink after handling
        self.actionType = nil // (1)
    }
    
    @discardableResult
    func handleDeeplink(action: String) -> Bool {
       actionType = ActionParser.shared.parseAction(action)
        //print(deeplinkType)
       return actionType != nil
    }
}
