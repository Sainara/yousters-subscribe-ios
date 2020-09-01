//
//  ReportService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 31.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ReportService: YoustersNetwork {
    
    func report(uid:String, reason:String, complition: @escaping (Bool, String?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false, "noToken")
            return
        }
        
        let parameters = ["sub_uid" : uid, "reason" : reason]
        
        AF.request(URLs.reportSubscribe, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    complition(true, nil)
                } else {
                    complition(false, json["message"].stringValue)
                }
            case .failure(let error):
                debugPrint(error)
                complition(false, "noConnection")
            }
        }
    }
    
    static let main = ReportService()
    
    override private init() {}

}

