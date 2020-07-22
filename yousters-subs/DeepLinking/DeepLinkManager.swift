//
//  DeepLinkManager.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 25.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//
import Foundation
import UIKit

class DeepLinkManager {
    private init() {}
    static let standart = DeepLinkManager()
    
    
    private var deeplinkType: DeeplinkType?
    // check existing deepling and perform action
    func checkDeepLink(viewController:UIViewController?) {
        print("checkDeepLink()")
        //print(deeplinkType)
        guard let deeplinkType = deeplinkType else {
            return
        }
        
        DeeplinkNavigator.shared.proceedToDeeplink(deeplinkType, viewController: viewController)
        // reset deeplink after handling
        self.deeplinkType = nil // (1)
    }
    
    @discardableResult
    func handleDeeplink(url: URL) -> Bool {
        print(url)
       deeplinkType = DeeplinkParser.shared.parseDeepLink(url)
        //print(deeplinkType)
       return deeplinkType != nil
    }
}
