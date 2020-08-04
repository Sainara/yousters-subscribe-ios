//
//  AuthError.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 01.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class AuthError: PrimaryError {
        
    func getPrettyString() -> String {
        switch error {
        case .tooManyRequests:
            return "Слишком много запросов"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
    
    enum ErrorType: String {
        case tooManyRequests = "tooManyRequests", unknown
    }
    
}
