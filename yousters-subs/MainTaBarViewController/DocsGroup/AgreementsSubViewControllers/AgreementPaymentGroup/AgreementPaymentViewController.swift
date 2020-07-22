//
//  AgreementPaymentViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 24.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import PassKit

class AgreementPaymentViewController: YoustersStackViewController {
    
    let payButton = YoustersButton(text: "Оплатить")
    
    let agr_uid:String
    
    let promoField = YoustersTextField(placehldr: "Промокод", fontSize: 19)
    let resultOfPromo = UILabel(text: "", font: Fonts.standart.gilroyRegular(ofSize: 15), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
    
    let summaryView = UIView()

    init(uid:String) {
        agr_uid = uid
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
//        let barItem = UIBarButtonItem(image: .init(imageLiteralResourceName: "share_doc"), style: .plain, target: self, action: #selector(shareTapped))
//        barItem.imageInsets = .init(top: 4, left: 0, bottom: -4, right: 0)
//        barItem.tintColor = .bgColor
//        
//        navigationItem.rightBarButtonItem = barItem
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        
        addItems()
        //addPromoCode()
        setupAgreement()
        addApplePay()
        makeSummary()
    
    }
    
    private func addItems() {
        addItem(title: "Разовое подписание", price: "39.00₽")
    }
    
    private func addItem(title:String, price:String) {
        let container = UIView()
        addWidthArrangedSubView(view: container, spacing: 30)
        
        let priceLabel = UILabel(text: title, font: Fonts.standart.gilroyMedium(ofSize: 19), textColor: .bgColor, textAlignment: .left, numberOfLines: 1)
        
        let price = UILabel(text: price, font: Fonts.standart.gilroyMedium(ofSize: 22), textColor: .bgColor, textAlignment: .right, numberOfLines: 1)
        
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
    
    private func makeSummary() {
        view.addSubview(summaryView)
        
        let priceLabel = UILabel(text: "Итого:", font: Fonts.standart.gilroyMedium(ofSize: 23), textColor: .bgColor, textAlignment: .left, numberOfLines: 1)
        
        let price = UILabel(text: "39.00₽", font: Fonts.standart.gilroySemiBoldName(ofSize: 26), textColor: .bgColor, textAlignment: .right, numberOfLines: 1)
        
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
    
    @objc private func pay() {
        let loading = UIAlertController(style: .loading)
        self.present(loading, animated: true, completion: nil)
        PaymentService.main.initPayment(uid: agr_uid) { (result) in
            loading.dismiss(animated: false) {
                guard let uid = result else {
                    return
                }
                let checkout = CheckoutViewController(url: URLs.getCheckout(uid: uid))
                checkout.modalPresentationStyle = .popover
                self.present(checkout, animated: true, completion: nil)
            }
        }
    }
    
    private func addPromoCode() {
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
    
    private func addApplePay() {
        view.addSubview(payButton)
        
    }
    
    private func setupAgreement() {
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
            make.leading.equalToSuperview().offset(10)
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
    
    
//    private var paymentRequest: PKPaymentRequest = {
//        let request = PKPaymentRequest()
//        request.merchantIdentifier = "merchant.com.tommysirenko.yousterssubsapp"
//        request.supportedNetworks = [.visa, .masterCard]
//        //request.supportedCountries = ["UA"]
//        request.merchantCapabilities = .capability3DS
//        request.countryCode = "RU"
//        request.currencyCode = "RUB"
//        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Подписание", amount: 39.99)]
//        return request
//    }()

}

//extension AgreementPaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
//
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//    }
//
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//
//}
