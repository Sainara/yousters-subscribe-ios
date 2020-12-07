//
//  ExecutorsCollectionViewCell.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 16.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import UIKit

class ExecutorsCollectionViewCell: UICollectionViewCell {
    
    var offer:Offer?
    
    let mainStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(offer:Offer) {
        
        subviews.forEach({$0.removeFromSuperview()})
        mainStack.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        self.offer = offer
        backgroundColor = .bgColor
        
        layer.cornerRadius = 9
        layer.borderWidth = 2
        
        switch offer.level {
        case .economy:
            layer.borderColor = UIColor.bronzeColor.cgColor
        case .profi:
            layer.borderColor = UIColor.silverColor.cgColor
        case .premium:
            layer.borderColor = UIColor.buttonDisabled.cgColor
        case .unknown:
            break
        }
        clipsToBounds = true
        
        addSubview(mainStack)
        mainStack.axis = .vertical
        mainStack.layoutMargins = .allSides(10)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let name = UILabel(text: offer.shortName, font: Fonts.standart.gilroyMedium(ofSize: 13), textColor: .white, textAlignment: .left, numberOfLines: 1)
        
        mainStack.addArrangedSubview(name)
        
        let price = UILabel(text: "\(offer.price)₽", font: Fonts.standart.gilroySemiBoldName(ofSize: 17), textColor: .white, textAlignment: .left, numberOfLines: 0)
        
        mainStack.addArrangedSubview(price)
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
