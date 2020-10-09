//
//  DialogWrap.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 07.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Starscream
import SwiftyJSON

class DialogWrap {
    var dialog:Dialog
    var socket:DialogSocket
    
    var delegate:DialogWrapDelegate?
    
    init(dialog:Dialog, socket:DialogSocket) {
        self.dialog = dialog
        self.socket = socket
    }
    
    func connect() {
        socket.addDelegate(delegate: self)
        socket.connect(withHeaders: [.token])
    }
    
    deinit {
        socket.removeDelegate(delegate: self)
        socket.socket?.disconnect()
    }
}

extension DialogWrap: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let json = JSON(parseJSON: text)
        for item in json.arrayValue {
            //print("item")
            let message = Message(data: item)
            if dialog.messages.contains(where: { (m) -> Bool in
                m.messageId == message.messageId
            }) {
                continue
            }
            dialog.messages.append(message)
            
        }
        delegate?.websocketDidReceiveMessage(text: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
}
