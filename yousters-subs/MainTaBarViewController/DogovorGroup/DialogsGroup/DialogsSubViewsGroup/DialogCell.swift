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
        
        let thStackView = UIStackView()
        thStackView.axis = .horizontal
        thStackView.spacing = 5
        thStackView.distribution = .fillProportionally
        
        //stackView.addArrangedSubview(thStackView)
        
        let title = UILabel(text: dialog.title, font: Fonts.standart.gilroyMedium(ofSize: 21), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(title)
        //thStackView.addArrangedSubview(makeCategoryView(type: dialog.type))
        //thStackView.addArrangedSubview(title)
        
        
    
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = 5
                
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
        case .audio( _):
            lastMggTxt = "🎤 Голосовое сообщение"
        default:
            break
        }
        
        dialog.lastMessage = dialog.messages.last?.sender.senderId == Sender.pasrseSender()?.senderId ? "Вы: \(lastMggTxt)" : lastMggTxt
        dialog.isLastMessageNotReaded = dialog.messages.last?.isRead
        

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
    
    private func makeCategoryView(type: Dialog.Types) -> UIView {
        let view = UIView()
        view.backgroundColor = .bgColor
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        let label = UILabel(text: nil, font: Fonts.standart.gilroyMedium(ofSize: 14), textColor: .white, textAlignment: .center, numberOfLines: 1)
        
        switch type {
        case .create:
            label.text = "ДЮ"
        default:
            label.text = "X3"
        }
        
        view.addSubview(label)
        
        view.snp.makeConstraints { (make) in
            make.width.equalTo(label.text!.widthOfString(usingFont: Fonts.standart.gilroyMedium(ofSize: 14)))
        }
        label.fillSuperview(padding: .init(top: 4, left: 10, bottom: 4, right: 10))
        
        return view
    }
}
