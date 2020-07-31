//
//  PaymentController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import StoreKit

class PaymentController: YoustersStackViewController, ReloadProtocol {
    
    let payButton = YoustersButton(text: "Оплатить")
    
    let product:SKProduct
    let reload_page:ReloadProtocol
    
    var paymentID:String!
    var agreementID:String?
    
    var items:[Item] = []
    var type:PaymentService.PaymentType
        
    let promoField = YoustersTextField(placehldr: "Промокод", fontSize: 19)
    let resultOfPromo = UILabel(text: "", font: Fonts.standart.gilroyRegular(ofSize: 15), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
    
    let summaryView = UIView()
    let loading = UIAlertController(style: .loading)

    init(product:SKProduct, page:ReloadProtocol, items:[Item], type:PaymentService.PaymentType) {
        reload_page = page
        self.items = items
        self.type = type
        self.product = product
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        scrollView.contentInset = .init(top: 30, left: 0, bottom: 0, right: 0)
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 15
        
        bottomOffset = -20
        bottomPaddinng = 20

        setup()
        
        navigationItem.title = "Оплата"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func setup() {
        
        addItems()
        //addPromoCode()
        setupAgreement()
        addApplePay()
        makeSummary()
    
    }
    
    internal func addItems() {
        items.forEach({addItem(item: $0)})
    }
    
    internal func addItem(item:Item) {
        let container = UIView()
        addWidthArrangedSubView(view: container, spacing: 30)
        
        let priceLabel = UILabel(text: item.title, font: Fonts.standart.gilroyMedium(ofSize: 19), textColor: .bgColor, textAlignment: .left, numberOfLines: 1)
        
        let priceText = "\(item.amount) x \(item.price).00₽"
        let price = UILabel(text: priceText, font: Fonts.standart.gilroyMedium(ofSize: 22), textColor: .bgColor, textAlignment: .right, numberOfLines: 1)
        
        container.addSubview(priceLabel)
        container.addSubview(price)
        container.backgroundColor = .white
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
            make.width.equalTo(200)
        }
        price.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(5)
            make.trailing.equalToSuperview()
            make.leading.equalTo(priceLabel.snp.trailing)
        }
    }
    
    internal func makeSummaryString() -> Int {
        var price = 0
        items.forEach { (item) in
            price += item.amount * item.price
        }
        return price
    }
    
    internal func makeSummary() {
        view.addSubview(summaryView)
        
        let priceLabel = UILabel(text: "Итого:", font: Fonts.standart.gilroyMedium(ofSize: 23), textColor: .bgColor, textAlignment: .left, numberOfLines: 1)
        
        let price = UILabel(text: "\(makeSummaryString()).00₽", font: Fonts.standart.gilroySemiBoldName(ofSize: 26), textColor: .bgColor, textAlignment: .right, numberOfLines: 1)
        
        summaryView.addSubview(priceLabel)
        summaryView.addSubview(price)
        summaryView.addSubview(payButton)
        summaryView.backgroundColor = .white
    
        summaryView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(bottomOffset).constraint
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(payButton.snp.top).offset(-15)
            make.leading.equalToSuperview()
            make.width.equalTo(100)
        }
        price.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(payButton.snp.top).offset(-15)
            make.trailing.equalToSuperview()
            make.leading.equalTo(priceLabel.snp.trailing)
        }
        
        payButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        payButton.isEnabled = false
        payButton.layer.opacity = 0.7
        payButton.addTarget(self, action: #selector(pay), for: .touchUpInside)
    }
    
    @objc internal func pay() {
    
        SKPaymentQueue.default().add(self)
        print(product.productIdentifier)
        
        let payment = SKMutablePayment(product: product)
        payment.quantity = 1
        
        self.present(loading, animated: true, completion: nil)
        
        var someID = ""
        
        switch type {
        case .agreement:
            someID = agreementID ?? ""
        case .paket:
            someID = product.productIdentifier
        }
        
        PaymentService.main.initPayment(type: type, uid: someID) { (result) in
            
            guard let uid = result else {
                self.loading.dismiss(animated: false, completion: nil)
                let error = UIAlertController(style: .errorMessage)
                self.present(error, animated: false, completion: nil)
                return
            }
            
            self.paymentID = uid
            print(uid)
//            let checkout = CheckoutViewController(url: URLs.getCheckout(uid: uid), parentVC: self)
//            checkout.modalPresentationStyle = .popover
//            self.present(checkout, animated: true, completion: nil)
            
            SKPaymentQueue.default().add(payment)
            
        }
    }
    
    internal func addPromoCode() {
        let container = UIView()
        
        container.backgroundColor = .backgroundColor
        container.layer.cornerRadius = 7
        container.clipsToBounds = true
        
        let apply = YoustersButton(text: "Применить", height: 35)
        
        addWidthArrangedSubView(view: container)
        container.addSubview(promoField)
        container.addSubview(apply)
        container.addSubview(resultOfPromo)
        
        promoField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-15)
            
        }
        apply.snp.makeConstraints { (make) in
            make.centerY.equalTo(promoField.snp.centerY)
            make.width.equalTo(110)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(promoField.snp.trailing).offset(10)
        }
//        resultOfPromo.snp.makeConstraints { (make) in
//            make.top.equalTo(promoField.snp.bottom).offset(10)
//            make.leading.equalToSuperview()
//            make.trailing.equalTo(apply.snp.leading).offset(10)
//            make.bottom.equalToSuperview().offset(-10)
//        }
        
        apply.addTarget(self, action: #selector(checkPromo), for: .touchUpInside)
    }
    
    internal func addApplePay() {
        view.addSubview(payButton)
        
    }
    
    internal func setupAgreement() {
        let container = UIView()
        
        let text = UILabel(text: "Я согласен с условиями пользования", font: Fonts.standart.gilroyMedium(ofSize: 15), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        
        let checkmark = UISwitch()
        checkmark.onTintColor = .bgColor
        checkmark.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)

        
        addWidthArrangedSubView(view: container)
        container.addSubview(text)
        container.addSubview(checkmark)
        
        text.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        checkmark.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(text.snp.trailing).offset(10)
        }
        
        
    }
    
    @objc func switchValueDidChange(sender:UISwitch!) {
        print(sender.isOn)
        if sender.isOn {
            payButton.isEnabled = true
            UIView.animate(withDuration: 0.4) {
                self.payButton.layer.opacity = 1
            }
        } else {
            payButton.isEnabled = false
            UIView.animate(withDuration: 0.4) {
                self.payButton.layer.opacity = 0.7
            }
        }
    }
    
    @objc func checkPromo() {
        resultOfPromo.text = "Success"
        resultOfPromo.textColor = .green
    }
    
    func reload() {
        
    }
    
    struct Item {
        var title:String, price:Int, amount:Int
        
        init(product:SKProduct, amount:Int) {
            title = product.localizedTitle
            price = Int(product.price.description(withLocale: Locale(identifier: "ru_RU"))) ?? 0
            self.amount = amount
        }
    }
}

