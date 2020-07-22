//
//  SaveRestoreProvider.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation

class SaveRestoreProvider {
    
    private static let tokenKey = "tokenKey"
    private static let baseUserKey = "userKey"
    private static let userIsValidKey = "\(baseUserKey)IsValid"
    private static let userIsOnValidationKey = "\(baseUserKey)IsOnValidation"
    private static let userPhoneKey = "\(baseUserKey)Phone"
    private static let userNameKey = "\(baseUserKey)Name"
    private static let userINNKey = "\(baseUserKey)INN"
    private static let userEmailKey = "\(baseUserKey)Email"
    
    private init() {}
    
    static let shared = SaveRestoreProvider()
    
    func saveToken(token:String?) {
        UserDefaults.standard.set(token, forKey: Self.tokenKey)
    }
    
    
    func restoreToken() -> String? {
        print(UserDefaults.standard.string(forKey: Self.tokenKey))
        return UserDefaults.standard.string(forKey: Self.tokenKey)
    }
    
    func saveUser(user:AbstractUser?) {
        UserDefaults.standard.set(user?.isValid, forKey: Self.userIsValidKey)
        UserDefaults.standard.set(user?.phone, forKey: Self.userPhoneKey)
        UserDefaults.standard.set(user?.isOnValidation, forKey: Self.userIsOnValidationKey)
        UserDefaults.standard.set(user?.name, forKey: Self.userNameKey)
        UserDefaults.standard.set(user?.inn, forKey: Self.userINNKey)
        UserDefaults.standard.set(user?.email, forKey: Self.userEmailKey)

    }
    
    func restoreUser() -> AbstractUser? {
        guard let phone = UserDefaults.standard.string(forKey: Self.userPhoneKey) else {return nil}
        let isValid = UserDefaults.standard.bool(forKey: Self.userIsValidKey)
        let isOnValidation = UserDefaults.standard.bool(forKey: Self.userIsOnValidationKey)
        let name = UserDefaults.standard.string(forKey: Self.userNameKey)
        let email = UserDefaults.standard.string(forKey: Self.userEmailKey)
        let inn = UserDefaults.standard.string(forKey: Self.userINNKey)
        return AbstractUser(phone: phone, isValid: isValid, isOnValidation: isOnValidation, name: name, inn: inn, email: email)
    }
}
