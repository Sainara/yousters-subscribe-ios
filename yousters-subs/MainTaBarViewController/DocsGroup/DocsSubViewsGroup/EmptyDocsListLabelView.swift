//
//  EmptyDocsListLabelView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 11.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class EmptyDocsListLabelView: UIView {

    init(opacity:Float = 1.0) {
        super.init(frame: .zero)
        layer.opacity = opacity
        snp.makeConstraints { (make) in
            make.width.equalTo(300)
        }
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func centered(xOffset:CGFloat = 0, yOffset:CGFloat = 0) {
        snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(xOffset)
            make.centerY.equalToSuperview().offset(yOffset)
        }
    }
    
    private func setupView() {
        
        let image = UIImageView(image: UIImage(imageLiteralResourceName: "empty"))
        addSubview(image)
        image.setImageColor(color: .blackTransp)
        image.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(65)
            make.centerX.equalToSuperview()
        }
        
        let text = "Вы пока ничего не добавили, чтобы это исправить нажмите на \"+\" вверху экрана"
        let label = UILabel(text: text, font: Fonts.standart.gilroyMedium(ofSize: 16), textColor: .blackTransp, textAlignment: .center, numberOfLines: 0)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(image.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
