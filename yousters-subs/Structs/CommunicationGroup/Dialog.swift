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
        lastMessage:String?,
        isLastMessageInCome:Bool?,
        isLastMessageNotReaded:Bool?,
        messages:[Message] = []
    
    
    init(data:JSON) {
        id = data["id"].intValue
        uid = data["uid"].stringValue
        title = data["title"].stringValue
        //status = DialogStatus.init(rawValue: data["status_id"].intValue) ?? .unknown
        
    }
    
    init() {
        id = 1
        uid = UUID().uuidString
        title = "Dovor podpisania"
        lastMessage = "Kak u vas dela?"
        isLastMessageInCome = true
        isLastMessageNotReaded = true
    }
}
