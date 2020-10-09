//
//  Message.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 03.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Kingfisher
import MessageKit
import SwiftyJSON
import UIKit

public struct Message: MessageType {
    public var sender: SenderType
    
    public var messageId: String
    
    public var sentDate: Date
    
    public var kind: MessageKind
    
    var text:String, type:MessageService.Types
    
    var isRead:Bool?, readTime:Date?
    
    init(data:JSON) {
        sender = Sender(senderId: data["creator_id"].stringValue, displayName: "")
        messageId = data["id"].stringValue
        text = data["m_content"].stringValue
        type = MessageService.Types(rawValue: data["m_type"].stringValue) ?? .text
        isRead = data["m_type"].boolValue
        sentDate = data["created_at"].stringValue.toISODate()?.date ?? Date()
        
        switch data["m_type"].stringValue {
        case "text":
            //let attributedString = NSAttributedString(string: data["m_content"].stringValue, attributes: [NSAttributedString.Key.font: Fonts.standart.gilroyRegular(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            kind = .text(data["m_content"].stringValue)
        case "image", "document":
            kind = .photo(MessageMedia(url: data["m_content"].url, image: UIImage(), placeholderImage: UIImage(), size: .init(width: 200, height: 200)))
        //case "document":
          //  kind = .
//        case "voice":
//            kind = .audio(<#T##AudioItem#>)
        default:
            kind = .text(data["m_content"].stringValue)
        }
        
    }

}

struct MessageMedia: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct MessageVoice: AudioItem {
    var url: URL
    var duration: Float
    var size: CGSize
}
