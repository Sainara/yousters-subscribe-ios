//
//  DialogPageViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 01.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import InputBarAccessoryView
import MessageKit
import UIKit

class DialogPageViewController: MessagesViewController {
    
    var dialog:Dialog
    
    var sender:Sender!
    
    weak var dialogSocket:DialogSocket?
    
    var messages = [Message]()
        
    open lazy var attachmentManager: ScribeAttachementManager = { [unowned self] in
        let manager = ScribeAttachementManager()
        manager.delegate = self
        return manager
    }()
    
    let scribeInputView = ScribeInputView()
    
    lazy var offersListView = ExecutorsListView()
    lazy var completePaymentView = CompletePaymentView()
    
    lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        scribeInputView.recordDelegate = self
        messageInputBar = scribeInputView
        messageInputBar.delegate = self
        
        messageInputBar.inputPlugins = [attachmentManager]
        
        messagesCollectionView.showsVerticalScrollIndicator = false
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.alpha = 0
        messageInputBar.inputTextView.tintColor = .bgColor
     
        showMessageTimestampOnSwipeLeft = true
        scrollsToBottomOnKeyboardBeginsEditing = true
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.textMessageSizeCalculator.messageLabelFont = Fonts.standart.gilroyRegular(ofSize: 15)
            
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.audioMessageSizeCalculator.incomingAvatarSize = .zero
            layout.audioMessageSizeCalculator.outgoingAvatarSize = .zero
            
            layout.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
            layout.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
            layout.setMessageIncomingAccessoryViewPosition(.messageCenter)
            layout.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
            layout.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
            layout.setMessageOutgoingAccessoryViewPosition(.messageCenter)
            
            
            layout.setMessageOutgoingCellBottomLabelAlignment(.init(textAlignment: .right, textInsets: .init(top: 0, left: 0, bottom: 0, right: 10)))
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title ?? "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: Fonts.standart.gilroySemiBoldName(ofSize: 16)], for: .normal)
        navigationItem.largeTitleDisplayMode = .never
        
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: false)
        
        dialogSocket?.addDelegate(delegate: self)
        
        updateDialogAfterStatusChange()
    }
    
    func updateStatusAfterPayment() {
        switch dialog.status {
        case .created:
            print("updateStatusAfterPayment")
            dialog.status = .prepaid
        case .waitfullpay:
            dialog.status = .fullpaid
        default:
            break
        }
        
        updateDialogAfterStatusChange()
    }
    
    func updateDialogAfterStatusChange() {
        switch dialog.status {
        case .created:
            offersListView.parentViewController = self
            scribeInputView.setTopStackView(items: [offersListView])
            offersListView.offers = dialog.offers
            offersListView.collectionView.reloadData()
        case .prepaid:
            messageInputBar.setStackViewItems([], forStack: .top, animated: true)
            offersListView.removeFromSuperview()
        case .waitfullpay:
            completePaymentView.parentViewController = self
            scribeInputView.setTopStackView(items: [completePaymentView])
        case .fullpaid:
            messageInputBar.setStackViewItems([], forStack: .top, animated: true)
            completePaymentView.removeFromSuperview()
        default:
            break
        }
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioController.stopAnyOngoingPlaying()
    }
    
    deinit {
        print("DialogPageVC deinit")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dialogSocket?.removeDelegate(delegate: self)
    }
    
}

extension DialogPageViewController: VoiceRecordedDelegate {
    func successVoiceRecord(file url: URL) {
        messageInputBar.sendButton.startAnimating()
        dialogSocket?.writeMessage(url: url, type: .voice)
    }
}
