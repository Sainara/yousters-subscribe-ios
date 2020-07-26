//
//  AbstractUser.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import SwiftyJSON

class AbstractUser {
    var phone:String, isValid:Bool, isOnValidation:Bool, name:String?, inn:String?, email:String?, isPhiz:Bool?
    
    init(data:JSON) {
        self.phone = data["phone"].stringValue
        self.isValid = data["isvalidated"].boolValue
        self.isOnValidation = data["is_on_validation"].boolValue
        self.name = data["user_name"].string
        self.inn = data["inn"].string
        self.email = data["email"].string
        self.isPhiz = data["isPhiz"].bool
    }
    
    init(phone:String, isValid:Bool, isOnValidation:Bool, name:String?, inn:String?, email:String?, isPhiz:Bool?) {
        self.phone = phone
        self.isValid = isValid
        self.isOnValidation = isOnValidation
        self.name = name
        self.inn = inn
        self.email = email
        self.isPhiz = isPhiz
    }
    
    func isSimilar(a:AbstractUser) -> Bool {
        if a.phone == phone, a.isValid == isValid, a.isOnValidation == isOnValidation, a.email == email, a.inn == inn, a.name == name, a.isPhiz == isPhiz {
            return true
        }
        return false
    }
}
