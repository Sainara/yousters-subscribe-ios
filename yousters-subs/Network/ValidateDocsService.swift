//
//  ValidateDocsService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 14.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ValidateDocsService: YoustersNetwork {
    
    func sendDocs(data:DocsToValidateData, complition: @escaping (Bool)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false)
            return
        }
        
        AF.upload(multipartFormData: { (multi) in
            
            multi.append(data.main, withName: "main")
            multi.append(data.second, withName: "secondary")
            multi.append(data.video, withName: "video")

            multi.append(data.inn.data(using: .utf8, allowLossyConversion: false)!, withName: "inn")
            multi.append(data.email.data(using: .utf8, allowLossyConversion: false)!, withName: "email")

        }, to: URLs.uploadDocsToValid, headers: headers).responseJSON { response in
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
    
    func sendNonPhizToValidation(data:NonPhizData, complition: @escaping (Bool)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false)
            return
        }
        
        let parameters = ["inn" : data.inn, "email": data.email]
        
        AF.request(URLs.uploadNonPhizData, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
    
    static let main = ValidateDocsService()
    
    private override init() {}
}

struct NonPhizData {
    var inn:String, email:String
}

struct DocsToValidateData {
    var inn:String, email:String, main:URL, second:URL, video:URL
}
