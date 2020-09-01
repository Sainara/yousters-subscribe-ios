//
//  CodeView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 18.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class CodeView: UIView {
    
    var entered = ""
    let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        stackView.spacing = 15
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        renderCirlce()
    }
    
    func setEntered(code:String) {
        entered = code
        print(code)
        renderCirlce()
    }
    
    private func isActive(thanWhat:Int) -> Bool {
        entered.count >= thanWhat
    }
    
    private func renderCirlce() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        stackView.addArrangedSubview(setupCircle(isActive: isActive(thanWhat: 1)))
        stackView.addArrangedSubview(setupCircle(isActive: isActive(thanWhat: 2)))
        stackView.addArrangedSubview(setupCircle(isActive: isActive(thanWhat: 3)))
        stackView.addArrangedSubview(setupCircle(isActive: isActive(thanWhat: 4)))

    }
    
    private func setupCircle(isActive:Bool = false) -> UIView {
        let cirlce = UIView()
        if isActive {
            cirlce.backgroundColor = .bgColor
            cirlce.layer.opacity = 1
        } else {
            cirlce.backgroundColor = .blackTransp
            cirlce.layer.opacity = 0.5

        }
        cirlce.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
        
        cirlce.layer.cornerRadius = 7
        cirlce.clipsToBounds = true
        
        return cirlce
    }
}
