//
//  OfferInfoViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 28.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import UIKit

class OfferInfoViewController: YoustersStackViewController {
    
    let offer:Offer
    
    weak var parentViewControllerCustom:ExecutorsListView?
    
    init(offer:Offer) {
        self.offer = offer
        super.init(nibName: nil, bundle: nil)
        
        setup()
        
        scrollView.contentInset = .init(top: 30, left: 0, bottom: 0, right: 0)
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 15
        
        bottomOffset = -20
        bottomPaddinng = 20
    }
    
    func setup() {
        let title = UILabel(text: offer.title, font: Fonts.standart.gilroyMedium(ofSize: 22), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: title)
        
        addInfo(title: "\(offer.price)", sub: "Цена")
        addInfo(title: "\(offer.price / 5)", sub: "Предоплата")
        addInfo(title: "\(offer.description)", sub: "Комментрий юриста")
        //addInfo(title: "Information about prepay and another", sub: "Информация")
        
        let continueButton = YoustersButton(text: "Продолжить")
        
        view.addSubview(continueButton)
        
        continueButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottomOffset).constraint
        }
        
        continueButton.addTarget(self, action: #selector(cont), for: .touchUpInside)
    }
    
    @objc private func cont() {
        self.dismiss(animated: true) { [self] in
            let title = "Предоплата: \(offer.title)"
            let controller = DocumentServicePaymentViewController(offerUID: offer.uid, items: [.init(title: title, price: offer.price / 5, amount: 1)], page: parentViewControllerCustom)
            parentViewControllerCustom?.parentViewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
