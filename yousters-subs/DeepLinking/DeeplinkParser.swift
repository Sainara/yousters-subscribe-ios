//
//  DeeplinkParser.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 25.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation

class DeeplinkParser {
    static let shared = DeeplinkParser()
    private init() { }
    
    func parseDeepLink(_ url: URL) -> DeeplinkType? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
            return nil
        }
        var pathComponents = components.path.components(separatedBy: "/")
        pathComponents.removeFirst()
        
        let case_ = pathComponents.first!
        
        print(host)
        print(pathComponents)
        print(case_)
        switch case_ {
        case "case":
            if let agreementUID = pathComponents.last {
                return DeeplinkType.agreement(uid: agreementUID)
            }
        default:
            break
        }
        return nil
    }
}
