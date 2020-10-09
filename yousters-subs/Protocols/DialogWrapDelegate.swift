//
//  DialogWrapDelegate.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 07.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

protocol DialogWrapDelegate: class {
    //func websocketDidConnect()
//    func websocketDidDisconnect(error: Error?)
    func websocketDidReceiveMessage(text: String)
//    func websocketDidReceiveData(data: Data)
}
