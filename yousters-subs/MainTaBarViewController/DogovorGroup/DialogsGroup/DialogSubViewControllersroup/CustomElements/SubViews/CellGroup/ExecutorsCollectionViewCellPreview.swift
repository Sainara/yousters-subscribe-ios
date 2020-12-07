//
//  ExecutorsCollectionViewCellPreview.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 22.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import UIKit

class ExecutorsCollectionViewCellPreview: UICollectionViewCell {
    
    let text = "Ожидание предложений"
    
    var dotCounter = 0
    let price = UILabel(text: nil, font: Fonts.standart.gilroySemiBoldName(ofSize: 14), textColor: .buttonDisabled, textAlignment: .left, numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure() {
        subviews.forEach({$0.removeFromSuperview()})
        
        backgroundColor = .secondaryButtonColor
        layer.cornerRadius = 9
        clipsToBounds = true
        
        price.text = text
        
        addSubview(price)
        price.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        updateText()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText() {
        switch dotCounter % 4 {
        case 0:
            price.text = text + "."
        case 1:
            price.text = text + ".."
        case 2:
            price.text = text + "..."
        case 3:
            price.text = text + ""
        default:
            break
        }
        
        dotCounter += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.updateText()
        }
    }
}
