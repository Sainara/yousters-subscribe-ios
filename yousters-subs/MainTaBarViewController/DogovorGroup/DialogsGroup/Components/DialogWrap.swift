//
//  DialogWrap.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 07.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import Starscream
import SwiftyJSON

class DialogWrap {
    var dialog:Dialog
    var socket:DialogSocket
    
    weak var delegate:DialogWrapDelegate?
    
    init(dialog:Dialog, socket:DialogSocket) {
        self.dialog = dialog
        self.socket = socket
    }
    
    func connect() {
        socket.addDelegate(delegate: self)
        socket.connect(withHeaders: [.token])
    }
    
    func disconnect() {
        socket.removeDelegate(delegate: self)
        socket.disconnect()
    }
    
    deinit {
        print("DialogWrap deinit")
    }
}

extension DialogWrap: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {}
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {}
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let json = JSON(parseJSON: text)
        
        switch json["type"].stringValue {
        case "message":
            for item in json["data"].arrayValue {
                let message = Message(data: item)
                if dialog.messages.contains(message) {
                    continue
                }
                dialog.messages.append(message)
            }
        case "offer":
            for item in json["data"].arrayValue {
                let offer = Offer(data: item)
                if dialog.offers.contains(offer) {
                    continue
                }
                dialog.offers.append(offer)
            }
        case "execOffer":
            dialog.executorOffer = Offer(data: json["data"])
        case "status":
            dialog.status = Dialog.Status(rawValue: json["data"].stringValue) ?? .unknown
        default:
            break
        }
        
        delegate?.websocketDidReceiveMessage(text: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
    
    
}
