//
//  Validations.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 14.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation

class Validations {
    static func checkPhoneNumer(number:String) -> Bool {
        let regexp = try! NSRegularExpression(pattern: "^((\\+7|7|8)+([0-9]){10})$")
        return regexp.matches(number)
    }
    
    static func checkEmail(email:String) -> Bool {
        let regexp = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return regexp.matches(email)
    }
    
    static func checkINN(inn:String) -> Bool {
        let regexp = try! NSRegularExpression(pattern: "^([0-9]{10}|[0-9]{12})$")
        return regexp.matches(inn)
    }
}
