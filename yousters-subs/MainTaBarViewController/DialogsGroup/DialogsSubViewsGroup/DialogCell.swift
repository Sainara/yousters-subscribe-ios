//
//  DialogCell.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 30.09.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell {
    
    var dialog:Dialog
    
    let stackView = UIStackView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    init(reuseIdentifier:String?, dialog:Dialog) {
        self.dialog = dialog
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        addSubview(stackView)
        stackView.fillSuperview()
        stackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 40)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 7
        
        let title = UILabel(text: dialog.title, font: Fonts.standart.gilroyMedium(ofSize: 21), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(title)
    
        let hStackView = UIStackView()
        
        
        //print(dialog.messages.last?.sender.senderId)
        
        var lastMggTxt = ""
        
        switch dialog.messages.last?.kind {
        case .text(let text):
            lastMggTxt = text
        case .photo( _):
            switch dialog.messages.last?.type {
            case .document:
                lastMggTxt = "📎 Документ"
            default:
                lastMggTxt = "📷 Фотография"
            }
        default:
            break
        }
        
        dialog.lastMessage = dialog.messages.last?.sender.senderId == Sender.pasrseSender()?.senderId ? "Вы: \(lastMggTxt)" : lastMggTxt
        dialog.isLastMessageNotReaded = dialog.messages.last?.isRead
        
        //print(dialog.messages.last)
        
        hStackView.axis = .horizontal
        hStackView.spacing = 5
//        hStackView.isLayoutMarginsRelativeArrangement = true
//        hStackView.layoutMargins = .init(top: 3, left: 0, bottom: 3, right: 0)
        
        let lastMessageText = UILabel(text: dialog.lastMessage, font: Fonts.standart.gilroyRegular(ofSize: 16), textColor: .blackTransp, textAlignment: .left, numberOfLines: 1)
        
//        if !(dialog.isLastMessageNotReaded ?? false) {
//            let statusbgView = UIView()
//            statusbgView.backgroundColor = .bgColor
//            statusbgView.layer.cornerRadius = 6.5
//            statusbgView.clipsToBounds = true
//
//            statusbgView.snp.makeConstraints { (make) in
//                make.width.equalTo(13)
//                make.height.equalTo(13)
//            }
//
//            hStackView.addArrangedSubview(statusbgView)
//
//        }
                
        hStackView.addArrangedSubview(lastMessageText)
        stackView.addArrangedSubview(hStackView)
        
        accessoryType = .disclosureIndicator
        
    }
}
