//
//  DialogViewControllerMessageKit.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 09.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import MessageKit
import Kingfisher

extension DialogPageViewController: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            
        }
    }
    func didTapImage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            self.present(YoustersWKWebViewController(url: messages[indexPath.section].text), animated: true, completion: nil)
        }
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            print("Failed to identify message when audio cell receive tap gesture")
            return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
}

extension DialogPageViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return sender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTimestampLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sentDate = message.sentDate
        let sentDateString = CustomMessageKitDate.shared.string(from: sentDate)
        let timeLabelFont: UIFont = .boldSystemFont(ofSize: 10)
        let timeLabelColor: UIColor
        if #available(iOS 13, *) {
            timeLabelColor = .systemGray
        } else {
            timeLabelColor = .darkGray
        }
        return NSAttributedString(string: sentDateString, attributes: [NSAttributedString.Key.font: timeLabelFont, NSAttributedString.Key.foregroundColor: timeLabelColor])
    }
}

extension DialogPageViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return true }
        return messages[indexPath.section].sentDate.isAfterDate(messages[indexPath.section - 1].sentDate, granularity: .hour)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].sender.senderId == messages[indexPath.section - 1].sender.senderId
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .bgColor
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .bgColor : .secondaryButtonColor
    }
    
    
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let item):
            imageView.kf.setImage(with: item.url, options: [
                .processor(DownsamplingImageProcessor(size: .init(width: 200, height: 200))),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        break
        default:
            break
        }
    }
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message)
    }
    
    // MARK: cellBottom
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section == messages.count - 1, message.sender.senderId == sender.senderId {
            return NSAttributedString(string: "Доставлено", attributes: [NSAttributedString.Key.font: Fonts.standart.gilroyMedium(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
        
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section == messages.count - 1, message.sender.senderId == sender.senderId {
            return 17
        }
        return 0
    }
    
    // MARK: cellTop
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isTimeLabelVisible(at: indexPath) ? 35 : 0
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: CustomMessageKitDate.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: Fonts.standart.gilroyMedium(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        if !isPreviousMessageSameSender(at: indexPath) {
//            let name = message.sender.displayName
//            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//        }
//        return nil
//    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        //        accessoryView.backgroundColor = .clear
        //
        //        if !isFromCurrentSender(message: message) {return}
        //
        //        let view = UIView()
        //        view.backgroundColor = .bgColor
        //        view.layer.cornerRadius = 5
        //        view.clipsToBounds = true
        //
        //        accessoryView.addSubview(view)
        //
        //        view.snp.makeConstraints { (make) in
        //            make.center.equalToSuperview()
        //            make.height.equalTo(10)
        //            make.width.equalTo(10)
        //        }
        //button.frame = accessoryView.bounds
        //button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
    }
}
