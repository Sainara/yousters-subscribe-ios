//
//  DialogSocket.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 06.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import Starscream

class DialogSocket: YoustersNetwork {
    
    var request:URLRequest
    var socket:WebSocket?
    
    var delegates:[WebSocketDelegate] = []

    init(url:String) {
        request = URLRequest(url: URL(string: url)!)
        socket = WebSocket(request: request)
        
    }
    
    func connect(withHeaders:[HTTPHeaderType] = []) {
        guard let headers = getHTTPHeaders(rawHeaders: withHeaders) else {
            return
        }
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }
        
        socket?.delegate = self
        socket?.request = request
        socket?.disableSSLCertValidation = true
        socket?.connect()
        
    }
    
    func writeMessage(content:String = "", url:URL! = nil, type:MessageService.Types) {
        
        let multipartdata = MultipartFormData()
        multipartdata.append(type.rawValue.data(using: .utf8, allowLossyConversion: false)!, withName: "type")
        
        switch type {
        case .text:
            multipartdata.append(content.data(using: .utf8, allowLossyConversion: false)!, withName: "content")
        case .image, .document:
            multipartdata.append(url, withName: "content")
        default:
            return
        }
        
        var data = "\(multipartdata.contentType)\n".data(using: .utf8)
    
        do {
            //try print(String(data: multipartdata.encode(), encoding: .utf8))
            try data?.append(multipartdata.encode())
            socket?.write(data: data!)
        } catch {
            print("fail encode")
            return
        }
    }
    
    func addDelegate(delegate:WebSocketDelegate) {
        if delegates.contains(where: { (s) -> Bool in
            s === delegate
        }) {
            return
        }
        delegates.append(delegate)
    }
    
    func removeDelegate(delegate:WebSocketDelegate) {
        let index = delegates.firstIndex(where: { (s) -> Bool in
            s === delegate
        })
        if let index = index {
            delegates.remove(at: index)
        }
    }
    
}

extension DialogSocket: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        delegates.forEach({$0.websocketDidConnect(socket: socket)})
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
            socket.connect()
        }
        delegates.forEach({$0.websocketDidDisconnect(socket: socket, error: error)})
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        delegates.forEach({$0.websocketDidReceiveMessage(socket: socket, text: text)})
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        delegates.forEach({$0.websocketDidReceiveData(socket: socket, data: data)})
    }
    
    
}
