//
//  DialogViewControllerInputBarAccessoryViewDelegate.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 09.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import InputBarAccessoryView

extension DialogPageViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        print("didPressSendButtonWith")
        
        let message = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //inputBar.sendButton.startAnimating()
        if !message.isEmpty {
            inputBar.inputTextView.text = ""
            dialogSocket?.writeMessage(content: message, type: .text)
        }
        
        attachmentManager.attachments.forEach { (attachment) in
            switch attachment {
            case .image(let image):
                image.getImageURL { [self] (url) in
                    dialogSocket?.writeMessage(url: url, type: .image)
                }
            case .url(let url):
                dialogSocket?.writeMessage(url: url, type: .document)
            default:
                break
            }
        }
        
        attachmentManager.invalidate()
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        //print("!!!!!!!!!!!!!!!!")
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        //print("!!!!!!!!!!!!!!!!")
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        //print("!!!!!!!!!!!!!!!!")
    }
}
