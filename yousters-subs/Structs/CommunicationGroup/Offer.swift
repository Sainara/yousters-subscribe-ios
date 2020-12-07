//
//  Offer.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 16.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import SwiftyJSON

struct Offer: Equatable, Comparable {
    static func == (lhs: Offer, rhs: Offer) -> Bool {
        lhs.uid == rhs.uid
    }
    
    static func < (lhs: Offer, rhs: Offer) -> Bool {
        lhs.level < rhs.level
    }
    
    var title:String, description:String, price:Int, uid:String, status:Status, level:Level, dialogUID:String
    
    init(data:JSON) {
        title = data["title"].stringValue
        description = data["description"].stringValue
        price = data["price"].intValue
        uid = data["uid"].stringValue
        status = Status(rawValue: data["status"].stringValue) ?? .unknown
        level = Level(rawString: data["level"].stringValue)
        dialogUID = data["dialog_uid"].stringValue
    }
    
    var shortName:String {
        var result = ""
        
        title.split(separator: " ").enumerated().forEach { (index, str) in
            if index == 0 {
                result += str + " "
            } else {
                result += String(str.first!) + ". "
            }
        }
        
        return result
    }
    
    enum Level: Int, Comparable {
        static func < (lhs: Offer.Level, rhs: Offer.Level) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case economy = 0, profi = 5, premium = 10, unknown = 999
        
        init(rawString:String) {
            switch rawString {
            case "economy":
                self = .economy
            case "profi":
                self = .profi
            case "premium":
                self = .premium
            default:
                self = .unknown
            }
        }
    }
    
    enum Status: String {
        case created, prePaid, fullPaid, unknown
    }
    
}
