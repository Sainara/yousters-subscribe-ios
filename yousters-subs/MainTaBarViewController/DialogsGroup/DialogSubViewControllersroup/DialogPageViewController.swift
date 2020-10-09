//
//  DialogPageViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 01.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire
import InputBarAccessoryView
import MessageKit
import Starscream
import SwiftyJSON
import UIKit



class DialogPageViewController: MessagesViewController {
    
    let dialog:Dialog
    
    var sender:Sender!
    
    var dialogSocket:DialogSocket?
    
    var messages = [Message]()
    
    open lazy var attachmentManager: ScribeAttachementManager = { [unowned self] in
        let manager = ScribeAttachementManager()
        manager.delegate = self
        return manager
    }()
    
    lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        // = MessageInputBar()
        messageInputBar = ScribeInputView()
        messageInputBar.delegate = self
        
        messagesCollectionView.scrollToBottom(animated: false)
        
        messageInputBar.inputPlugins = [attachmentManager]
        //messageInputBar.reloadPlugins()
        
        messagesCollectionView.showsVerticalScrollIndicator = false
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.alpha = 0
        messageInputBar.inputTextView.tintColor = .bgColor
        //messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .bottom, animated: false)
        messageInputBar.sendButton.configure({
            $0.image = UIImage(imageLiteralResourceName: "paper-plane")
            $0.title = ""
            //$0.setSize(.init(width: 200, height: 36), animated: false)
            $0.tintColor = .bgColor
        })
        
        showMessageTimestampOnSwipeLeft = true
        scrollsToBottomOnKeyboardBeginsEditing = true
        
        
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            
            //layout.textMessageSizeCalculator.
            
            layout.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
            layout.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
            layout.setMessageIncomingAccessoryViewPosition(.messageCenter)
            layout.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
            layout.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
            layout.setMessageOutgoingAccessoryViewPosition(.messageCenter)
            
            layout.textMessageSizeCalculator.messageLabelFont = Fonts.standart.gilroyRegular(ofSize: 14)
            
            layout.setMessageOutgoingCellBottomLabelAlignment(.init(textAlignment: .right, textInsets: .init(top: 0, left: 0, bottom: 0, right: 10)))
        }
        
        dialogSocket?.addDelegate(delegate: self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioController.stopAnyOngoingPlaying()
    }
    
    deinit {
        dialogSocket?.removeDelegate(delegate: self)
        print("Dialog closed")
    }
    
    init(dialog:Dialog, socket:DialogSocket) {
        self.dialog = dialog
        super.init(nibName: nil, bundle: nil)
        title = dialog.title
        
        messages = dialog.messages
    
        self.dialogSocket = socket
        
        sender = Sender.pasrseSender()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DialogPageViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("Connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error)
        print("DisConnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        //print(text)
        print("in text")
        
        var newMsgCount = 0
        
        let json = JSON(parseJSON: text)
        for item in json.arrayValue {
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
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        let json = JSON(data)
        print(data)
        print(json)
    }
}
