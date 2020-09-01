//
//  ActionParser.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 05.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation

class ActionParser {
    static let shared = ActionParser()
    private init() { }
    
    func parseAction(_ string: String) -> ActionType? {
        
        let data = string.split(separator: ":").map(String.init)
        
        switch data[0] {
        case "reloadAgreements":
            return ActionType.reloadAgreements
        case "reloadMe":
            return ActionType.reloadMe
        case "code":
            return .enterCode(code: data[1])
        default:
            break
        }
        return nil
    }
}
