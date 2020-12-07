//
//  ScribeAttachementManager.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 09.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import InputBarAccessoryView
import Kingfisher

class ScribeAttachementManager: AttachmentManager {
    override var tintColor: UIColor {
        return .bgColor
    }
    
    public override init() {
        super.init()
        //deleteButton.setTitle(nil, for: .normal)
        //deleteButton.setTitle(nil, for: .highlighted)
        //deleteButton.setImage(UIImage(imageLiteralResourceName: ""), for: .normal)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == attachments.count && showAddAttachmentCell {
            return createAttachmentCell(in: collectionView, at: indexPath)
        }
        
        let attachment = attachments[indexPath.row]
        
        if let cell = dataSource?.attachmentManager(self, cellFor: attachment, at: indexPath.row) {
            return cell
        } else {
            
            // Only images are supported by default
            switch attachment {
            case .image(let image):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAttachmentCell.reuseIdentifier, for: indexPath) as? ImageAttachmentCell else {
                    fatalError()
                }
                cell.attachment = attachment
                cell.indexPath = indexPath
                cell.manager = self
                cell.imageView.image = image
                cell.imageView.tintColor = tintColor
                cell.deleteButton.backgroundColor = tintColor
                return cell
            case .url(let url):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAttachmentCell.reuseIdentifier, for: indexPath) as? ImageAttachmentCell else {
                    fatalError()
                }
                cell.attachment = attachment
                cell.indexPath = indexPath
                cell.manager = self
                cell.imageView.kf.setImage(with: url, options: [
                    .processor(DownsamplingImageProcessor(size: .init(width: 100, height: 100))),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ])
                cell.imageView.tintColor = tintColor
                cell.deleteButton.backgroundColor = tintColor
                return cell
            default:
                return collectionView.dequeueReusableCell(withReuseIdentifier: AttachmentCell.reuseIdentifier, for: indexPath) as! AttachmentCell
            }
            
        }
        //return UICollectionViewCell()
    }
}


