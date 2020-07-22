//
//  AgreementService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 17.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class AgreementService: YoustersNetwork {
    
    private var sessionID:String?
    
    func addAgreementToAdded(uid:String ,complition: @escaping (Bool)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false)
            return
        }
        
        let parameters = ["uid": uid]
        print(parameters)
        
        AF.request(URLs.addAgreementToAdded, method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
    
    func getAgreements(complition: @escaping ([Agreement])->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition([])
            return
        }
        
        AF.request(URLs.getAgreements, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    var result = [Agreement]()
                    for item in json["data"].arrayValue {
                        result.append(Agreement(data: item))
                    }
                    complition(result)
                } else {
                    complition([])
                }
            case .failure(let error):
                debugPrint(error)
                complition([])
            }
        }
    }
    
    func getAgreement(uid:String, complition: @escaping (Agreement?)->Void) {
        
        AF.request(URLs.getAgreement(uid: uid)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    let agreement = Agreement(data: json["data"])
                    print(agreement)
                    complition(agreement)
                } else {
                    complition(nil)
                }
            case .failure(let error):
                debugPrint(error)
                complition(nil)
            }
        }
    }
    
    func getAgreementSubs(uid:String, complition: @escaping ([Subscriber])->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition([])
            return
        }
        
        let parameters = ["uid" : uid]
        
        AF.request(URLs.getAgreementSubs, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    var result = [Subscriber]()
                    for item in json["data"].arrayValue {
                        result.append(Subscriber(data: item))
                    }
                    complition(result)
                } else {
                    complition([])
                }
            case .failure(let error):
                debugPrint(error)
                complition([])
            }
        }
    }
    
    func uploadAgreement(title:String, location:URL, complition: @escaping (Bool)->Void) {
           
           guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
               complition(false)
               return
           }
           
           AF.upload(multipartFormData: { (multi) in
               
               multi.append(location, withName: "doc")
               multi.append(title.data(using: .utf8, allowLossyConversion: false)!, withName: "title")

           }, to: URLs.uploadAgreement, headers: headers).responseJSON { response in
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
    
    static let main = AgreementService()
    
    private override init() {}
}
