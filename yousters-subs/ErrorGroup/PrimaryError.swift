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
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
    
    static func showAlertWithError(vc:UIViewController, error:String?) {
        let message = PrimaryError(error: error ?? "").getPrettyString()
        let alert = UIAlertController(style: .errorMessage, message: message)
        vc.present(alert, animated: true, completion: nil)
    }
    
    enum ErrorType: String {
        case tooManyRequests = "tooManyRequests", unknown
    }
    
}
