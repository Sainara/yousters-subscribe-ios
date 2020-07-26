//
//  AgreementPaketService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 27.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class AgreementPaketService: YoustersNetwork {
    
    func usePaket(uid:String, complition: @escaping (Bool, String?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false, "noToken")
            return
        }
        
        let parameters = ["agr_uid":uid]
        
        AF.request(URLs.usePaket, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
    
    static let main = AgreementPaketService()
    
    override private init() {}
    
}
