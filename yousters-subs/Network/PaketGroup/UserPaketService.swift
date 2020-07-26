//
//  UserPaketService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class UserPaketService: YoustersNetwork {
    
    func getPakets(complition: @escaping ([Paket])->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition([])
            return
        }
        
        AF.request(URLs.getPakets, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    var pakets = [Paket]()
                    for item in json["data"].arrayValue {
                        pakets.append(Paket(data: item))
                    }
                    print(pakets)
                    complition(pakets)
                } else {
                    complition([])
                }
            case .failure(let error):
                debugPrint(error)
                complition([])
            }
        }
    }
    
    func getMyPaketsAndUsage(complition: @escaping (PaketsAndUsage?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(nil)
            return
        }
        
        AF.request(URLs.getMyPaketsAndUsage, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    let paketsAndUsage = PaketsAndUsage(data: json["data"])
                    print(paketsAndUsage)
                    complition(paketsAndUsage)
                } else {
                    complition(nil)
                }
            case .failure(let error):
                debugPrint(error)
                complition(nil)
            }
        }
    }
    
    static let main = UserPaketService()
    
    override private init() {}
    
}
