//
//  Subscriber.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 18.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import SwiftyJSON
import SwiftDate

struct Subscriber {
    var inn:String, phone:String, name:String, date:String, videoUrl:String, isVerified:String, uid:String
    
    init(data:JSON) {
        inn = data["inn"].stringValue
        phone = data["phone"].stringValue
        name = data["user_name"].stringValue
        date = data["created_at"].stringValue
        videoUrl = data["video_url"].stringValue
        isVerified = data["isverified"].stringValue
        uid = data["uid"].stringValue
    }
    
    func getFormatedString() -> String {
        let region = Region(calendar: Calendars.gregorian, zone: TimeZone.current, locale: Locales.russian)
        let date_ = date.toSQLDate(region: region)
        let formatedDate = date_!.toFormat("dd MMM yyyy 'в' HH:mm:ss")
        
        if Validations.checkINN(inn: inn) {
            return "\(name) (ИНН: \(inn)), \(formatedDate) при помощи кода, отправленного на номер телефона \(phone)"
        }
        
        return "\(name), \(formatedDate) при помощи кода, отправленного на номер телефона \(phone)"
    }
    
    func getVideoUrl() -> String {
        videoUrl
    }
}
