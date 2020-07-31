//
//  PaketCell.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import StoreKit

class PaketCell: UICollectionViewCell {
    
    var delegate:CellDelegate?
    var paket:SKProduct?
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(paket:SKProduct) {
        self.paket = paket
        subviews.forEach({$0.removeFromSuperview()})
        backgroundColor = .secondaryButtonColor
        layer.cornerRadius = 8
        clipsToBounds = true
        
        let localPaket = Paket(product: paket)
        
        let title = addTitleAndPrice(title: localPaket.getShortTitle(), price: localPaket.getPrice())
        let description = addDescription(description: localPaket.getDesc(), top: title)
        addBuyButton(top: description)

    }
    
    private func addTitleAndPrice(title:String, price:String) -> UIView {
        let title = UILabel(text: title, font: Fonts.standart.gilroySemiBoldName(ofSize: 23), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        
        let price = UILabel(text: price + "₽", font: Fonts.standart.gilroySemiBoldName(ofSize: 26), textColor: .bgColor, textAlignment: .right, numberOfLines: 0)
        addSubview(price)
        price.snp.makeConstraints { (make) in
            make.leading.equalTo(title.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        return title
    }
    
    
    private func addDescription(description:String, top:UIView) -> UIView {
        
        //let description = UILabel(text: description, font: Fonts.standart.gilroyMedium(ofSize: 19), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        let description = UITextView(text: description, font: Fonts.standart.gilroyMedium(ofSize: 15), textColor: .blackTransp, textAlignment: .left)
        description.isEditable = false
        description.isSelectable = false
        description.isUserInteractionEnabled = false
        description.backgroundColor = .clear
        description.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        addSubview(description)
        description.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(top.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            
        }
        
        return description
    }
    
    private func addBuyButton(top:UIView) {
        let button = YoustersButton(text: "Купить", fontSize: 16, height: 40, style: .basic)
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(top.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        button.addTarget(self, action: #selector(clickBuy), for: .touchUpInside)
    }
    
    @objc private func clickBuy() {
        guard let paket = paket else {return}
        delegate?.work(data: paket)
    }
}
