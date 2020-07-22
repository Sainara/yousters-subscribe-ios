//
//  AuthService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class AuthService: YoustersNetwork {
    
    private var sessionID:String?
    
    func sendPhone(phoneNumber:String, complition: @escaping (Bool)->Void) {
        let parameters = ["number" : phoneNumber]
        AF.request(URLs.auth, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            //print(response.request?.url)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    let sessionID = json["sessionid"].stringValue
                    self.sessionID = sessionID
                    print(sessionID)
                    complition(true)
                } else {
                    complition(false)
                }
            case .failure(let error):
                debugPrint(error)
                complition(false)
            }
            
        }
    }
    
    func sendCode(verificationCode:String, complition: @escaping (Bool, Bool)->Void) {
        
        guard let sessionID = sessionID else {
            complition(false, false)
            return
        }
        
        let parameters = ["sessionid" : sessionID, "code" : verificationCode]
        AF.request(URLs.validate, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            //print(response.request?.url)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                if json["success"].boolValue {
                    let token = json["token"].stringValue
                    App.shared.token = token
                    let user = AbstractUser(data: json["data"])
                    App.shared.currentUser = user
                    print(token)
                    print(user)
                    complition(true, user.isValid || user.isOnValidation)
                } else {
                    complition(false, false)
                }
            case .failure(let error):
                debugPrint(error)
                complition(false, false)
            }
            
        }
    }
    
    func me(complition: @escaping (AbstractUser?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(nil)
            return
        }
       
        AF.request(URLs.me, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                if json["success"].boolValue {
                    let user = AbstractUser(data: json["data"])
                    App.shared.currentUser = user
                    complition(user)
                } else {
//                    if json["message"] == "userNotFound" {
//                        App.shared.logOut()
//                    }
                    complition(nil)
                }
            case .failure(let error):
                debugPrint(error)
                complition(nil)
            }
            
        }
    }
    
    static let main = AuthService()
    
    override private init() {}
}
