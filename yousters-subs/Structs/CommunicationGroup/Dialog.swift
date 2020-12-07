//
//  Dialog.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 30.09.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import SwiftyJSON
import UIKit

struct Dialog {
    var id:Int,
        uid:String,
        title:String,
        type:Types,
        status:Status,
        executorID:Int?,
        lastMessage:String?,
        isLastMessageInCome:Bool?,
        isLastMessageNotReaded:Bool?,
        messages:[Message] = [],
        offers:[Offer] = [],
        executorOffer:Offer?
    
    
    init(data:JSON) {
        id = data["id"].intValue
        uid = data["uid"].stringValue
        title = data["title"].stringValue
        type = Types(rawValue: data["dialog_type"].stringValue) ?? .unknown
        status = Status(rawValue: data["dialog_status"].stringValue) ?? .unknown
        executorID = data["executor_id"].int
    }
    
    enum Types: String {
        case create = "create", audit = "audit", unknown
    }
    
    enum Status: String {
        case created = "created", prepaid = "prepaid", waitfullpay = "waitfullpay", fullpaid = "fullpaid", unknown
    }
    
}
