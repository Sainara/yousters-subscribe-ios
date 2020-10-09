//
//  MessageService.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 05.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MessageService: YoustersNetwork {
    
    func getMessages(dialogId:Int, complition: @escaping ([Message])->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition([])
            return
        }
        
        let parameters = ["dialog_id" : dialogId]
        
        AF.request(URLs.messagesBase, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            
            //print(response.debugDescription)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    var messages = [Message]()
                    
                    for item in json["data"].arrayValue {
                        let dialog = Message(data: item)
                        messages.append(dialog)
                    }
                    
                    complition(messages)
                } else {
                    complition([])
                }
            case .failure(let error):
                debugPrint(error)
                complition([])
            }
        }
    }
    
    func createMessage(content:String, type:Types, dialogId:Int, complition: @escaping (Message?, String?)->Void) {
        
        guard let headers = getHTTPHeaders(rawHeaders: basicHeaders) else {
            complition(nil, "noToken")
            return
        }
        //content, type, req.user.id, dialog_id
        let parameters = ["content" : content, "type": type.rawValue, "dialog_id": String(dialogId)]
        
        AF.request(URLs.messagesBase, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            print(response.debugDescription)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    complition(Message(data: json["data"]), nil)
                } else {
                    complition(nil, json["message"].stringValue)
                }
            case .failure(let error):
                debugPrint(error)
                complition(nil, "noConnection")
            }
        }
    }

    
    static let main = MessageService()
    
    override private init() {}
    
    enum Types:String {
        case text = "text", image = "image", voice = "voice", document = "document"
    }
}
