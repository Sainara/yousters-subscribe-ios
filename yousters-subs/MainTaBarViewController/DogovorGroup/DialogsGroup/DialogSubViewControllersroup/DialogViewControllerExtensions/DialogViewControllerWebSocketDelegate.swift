//
//  DialogViewControllerWebSocketDelegate.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 16.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import Starscream
import SwiftyJSON

extension DialogPageViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("Connected delegate in DialogPageViewController")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("DisConnected delegate in DialogPageViewController")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let json = JSON(parseJSON: text)
        
        switch json["type"].stringValue {
        case "message":
            var newMsgCount = 0
            
            for item in json["data"].arrayValue {
                let message = Message(data: item)
                if messages.contains(where: { (m) -> Bool in
                    m.messageId == message.messageId
                }) {
                    continue
                }
                newMsgCount += 1
                messages.append(message)
                
            }
            
            if newMsgCount > 0 {
                messagesCollectionView.reloadData()
                messagesCollectionView.scrollToBottom(animated: true)
                print(json)
                messageInputBar.sendButton.stopAnimating()
            }
        case "offer":
            for item in json["data"].arrayValue {
                let offer = Offer(data: item)
                if offersListView.offers.contains(offer) {
                    continue
                }
                offersListView.offers.append(offer)
                offersListView.collectionView.reloadData()
            }
        case "execOffer":
            dialog.executorOffer = Offer(data: json["data"])
        case "status":
            dialog.status = Dialog.Status(rawValue: json["data"].stringValue) ?? .unknown
            updateDialogAfterStatusChange()
        default:
            break
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        let json = JSON(data)
        print(data)
        print(json)
    }
}
