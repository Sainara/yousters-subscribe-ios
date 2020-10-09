//
//  DialogsService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 03.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class DialogsService: YoustersNetwork {
    
    func getDialogs(complition: @escaping ([Dialog])->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition([])
            return
        }
        
        AF.request(URLs.dialogsBase, method: .get, headers: headers).responseJSON { response in
            //print(response.request?.url)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    var dialogs = [Dialog]()
                    
                    for item in json["data"].arrayValue {
                        let dialog = Dialog(data: item)
                        dialogs.append(dialog)
                    }
                    
                    complition(dialogs)
                } else {
                    complition([])
                }
            case .failure(let error):
                debugPrint(error)
                complition([])
            }
        }
    }
    
    func createDialog(title:String, complition: @escaping (Bool, String?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(false, "noToken")
            return
        }
        
        let parameters = ["title" : title]
        
        AF.request(URLs.dialogsBase, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            print(response.debugDescription)
            
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

    
    static let main = DialogsService()
    
    override private init() {}
    
//    enum PaymentType {
//        case agreement, paket
//    }
}
