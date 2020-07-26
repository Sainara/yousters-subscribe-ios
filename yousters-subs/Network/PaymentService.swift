//
//  PaymentService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 14.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class PaymentService: YoustersNetwork {
    
    func initPayment(type:PaymentType, uid:String, complition: @escaping (String?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(nil)
            return
        }
        
        var parameters:Parameters = [:]
        
        switch type {
        case .agreement:
            parameters = ["type":"agreement", "agr_uid": uid]
        case .paket:
            parameters = ["type":"paket", "paket_id": uid]
        }
        
        AF.request(URLs.initPayment, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            //print(response.request?.url)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    complition(json["uid"].stringValue)
                } else {
                    complition(nil)
                }
            case .failure(let error):
                debugPrint(error)
                complition(nil)
            }
        }
    }
    
    static let main = PaymentService()
    
    override private init() {}
    
    enum PaymentType {
        case agreement, paket
    }
}
