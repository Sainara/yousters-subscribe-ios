//
//  Sender.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 03.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import MessageKit
import SwiftyJSON

public struct Sender: SenderType, Equatable {
    public let senderId: String

    public let displayName: String
    
    static func pasrseSender() -> Sender? {
        guard let token = App.shared.token else {
            return nil
        }
        let payload = token.components(separatedBy: ".")
        if payload.count > 1 {
            var payload64 = payload[1]
            while payload64.count % 4 != 0 {
                payload64 += "="
            }
            let payloadData = Data(base64Encoded: payload64,
                                   options:.ignoreUnknownCharacters)!
            
            let json = JSON(payloadData)
            return Sender(senderId: json["id"].stringValue, displayName: json["id"].stringValue)
        
        }
        
        return nil
    }
    
}
