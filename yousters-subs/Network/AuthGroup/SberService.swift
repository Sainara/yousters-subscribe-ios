//
//  SberService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 22.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class SberService: YoustersNetwork {
    
    func initAuth(complition: @escaping (AuthRequestData?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(nil)
            return
        }
        
        AF.request(URLs.sberInit, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                if json["success"].boolValue {
                    let data = AuthRequestData(data: json["data"])
                    complition(data)
                } else {
                    
                    complition(nil)
                }
            case .failure(let error):
                debugPrint(error)
                complition(nil)
            }
            
        }
    }
    
    static let main = SberService()
    
    override private init() {}
    
    struct AuthRequestData {
        var nonce:String, state:String, scope:String
        
        fileprivate init(data:JSON) {
            nonce = data["nonce"].stringValue
            state = data["state"].stringValue
            scope = data["scope"].stringValue
        }
    }
}

