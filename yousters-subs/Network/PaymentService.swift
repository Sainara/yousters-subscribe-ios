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
    
    func initPayment(type:PaymentType, uid:String, promoCode:String = "", complition: @escaping (String?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(nil)
            return
        }
        
        var parameters:Parameters = [:]
        
        switch type {
        case .agreement:
            parameters = ["type":"agreement", "agr_uid": uid, "promo_code": promoCode]
        case .paket:
            parameters = ["type":"paket", "paket_id": uid, "promo_code": promoCode]
        case .documentService:
            parameters = ["type":"documentService", "offer_id": uid, "promo_code": promoCode]
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
    
    func checkPayment(receipt:String, uid:String, complition: @escaping (Bool)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false)
            return
        }
        
        let parameters = ["receiptID": receipt, "orderID": uid]
        
        AF.request(URLs.checkPayment, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            //print(response.request?.url)
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
    
    func checkPromoCode(promoCode:String, complition: @escaping (Bool)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false)
            return
        }
        
        let parameters = ["promoCode": promoCode]
        
        AF.request(URLs.checkPromoCode, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response.debugDescription)
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
    
    static let main = PaymentService()
    
    override private init() {}
    
    enum PaymentType {
        case agreement, paket, documentService
    }
}
