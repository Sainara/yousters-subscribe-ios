//
//  SubscriptionServive.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 22.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class SubscriptionServive: YoustersNetwork {
    
    private var sessionID:String?
    
    func initSubscribe(uid:String, complition: @escaping (Bool)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false)
            return
        }
     
        let parameters = ["uid" : uid]
        
        AF.request(URLs.initSubscribe, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.sessionID = json["sessionid"].stringValue
                complition(json["success"].boolValue)
            case .failure(let error):
                debugPrint(error)
                complition(false)
            }
        }
    }
    
    func validateSubscribe(code:String, complition: @escaping (Bool)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false)
            return
        }
        
        guard let sessionID = sessionID else {
            complition(false)
            return
        }
        
        let parameters = ["sessionid" : sessionID, "code" : code]
        
        AF.request(URLs.validateSubscribe, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                complition(json["success"].boolValue)
            case .failure(let error):
                debugPrint(error)
                complition(false)
            }
        }
    }
    
    static let main = SubscriptionServive()
    
    override private init() {}
}

