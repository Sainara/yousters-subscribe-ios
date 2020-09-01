//
//  Agreement.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 15.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate

struct Agreement {
    var id:Int, title:String, serverHash:String, date:String, location:String, creatorID:Int, uid:String, status:AgreementStatus, number:String
    
    init(data:JSON) {
        id = data["id"].intValue
        title = data["title"].stringValue
        serverHash = data["hash"].stringValue
        date = data["created_at"].stringValue
        location = data["link"].stringValue
        creatorID = data["creator_id"].intValue
        uid = data["uid"].stringValue
        status = AgreementStatus.init(rawValue: data["status_id"].intValue) ?? .unknown
        number = data["unumber"].stringValue
    }
    
    func getFormatedTime() -> String {
        let region = Region(calendar: Calendars.gregorian, zone: TimeZone.current, locale: Locales.russian)
        let date_ = date.toSQLDate(region: region)
        return date_!.toFormat("dd MMM yyyy 'в' HH:mm:ss")
    }
}

enum AgreementStatus: Int {
    case initial = 1, paid = 5, waitKontrAgent = 7, active = 10, unknown = 999
    
    func getTitle() -> String {
        switch self {
        case .initial:
            return "Создан"
        case .unknown:
            return "Неизвестено"
        case .paid:
            return "Оплачен"
        case .waitKontrAgent:
            return "Ожидает подписания контрагента"
        case .active:
            return "Активно"
        }
    }
    
    func getColor() -> UIColor {
        switch self {
        case .unknown:
            return .blackTransp
        default:
            return .bgColor
        }
    }
}
