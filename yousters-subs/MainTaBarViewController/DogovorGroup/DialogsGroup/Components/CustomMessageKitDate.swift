//
//  CustomMessageKitDate.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 09.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation
import SwiftDate

class CustomMessageKitDate {
    
    public static let shared = CustomMessageKitDate()
    
    private init() {}
    
    public func string(from date: Date) -> String {
        return configureDate(for: date).capitalized(with: .current)
    }
    
    public func attributedString(from date: Date, with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let dateString = configureDate(for: date)
        return NSAttributedString(string: dateString, attributes: attributes)
    }
    
    func configureDate(for date: Date) -> String {
        switch true {
        case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
            return date.toFormat("HH:mm")
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
            return date.toFormat("EEEE, HH:mm", locale: Locale(identifier: "ru"))
            //formatter.dateFormat = "EEEE HH:mm"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
            //formatter.dateFormat = "E, d MMM, h:mm a"
            return date.toFormat("E, d MMM, HH:mm", locale: Locale(identifier: "ru"))
        default:
            return date.toFormat("MMM d, yyyy, HH:mm", locale: Locale(identifier: "ru"))
            //formatter.dateFormat = "MMM d, yyyy, h:mm a"
        }
    }
}
