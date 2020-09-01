//
//  PushService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 01.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PushService: YoustersNetwork {
    
    func addToken(deviceToken:String) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {return}
        
        let parameters = ["deviceToken" : deviceToken, "type" : "ios"]
        
        AF.request(URLs.tokenInteract, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    print("token added")
                } else {
                    print(json["message"].stringValue)
                    print("token not added")
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func removeToken() {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {return}
        
        let parameters = ["type" : "ios"]
        
        AF.request(URLs.tokenInteract, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    print("token deleted")
                } else {
                    print(json["message"].stringValue)
                    print("token not deleted")
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    static let main = PushService()
    
    override private init() {}

}

