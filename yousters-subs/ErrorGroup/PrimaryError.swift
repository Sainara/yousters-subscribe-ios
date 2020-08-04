//
//  PrimaryError.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class PrimaryError {
    
    var error:ErrorType
    
    init(error:String) {
        self.error = ErrorType(rawValue: error) ?? .unknown
    }
    
    func getPrettyString() -> String {
        switch error {
        case .tooManyRequests:
            return "Слишком много запросов"
        case .wrongCode:
            return "Неверный код"
        case .numberBlocked:
            return "Номер заблокирован"
        case .tooManyTries:
            return "Слишком много попыток"
        case .inValidName:
            return "Некоректное имя"
        case .unknown:
            return "Неизвестная ошибка"
        default:
            return error.rawValue
        }
    }
    
    static func showAlertWithError(vc:UIViewController, error:String?) {
        let message = PrimaryError(error: error ?? "").getPrettyString()
        let alert = UIAlertController(style: .errorMessage, message: message)
        vc.present(alert, animated: true, completion: nil)
    }
    
    enum ErrorType: String {
        case tooManyRequests = "tooManyRequests",
        numberBlocked = "numberBlocked",
        invalidPhoneNumber = "invalidPhoneNumber",
        invalidSessionID = "invalidSessionID",
        tooManyTries = "tooManyTries",
        sessionExpired = "sessionExpired",
        wrongCode = "wrongCode",
        inValidName = "inValidName",
        unknown
    }
    
}
