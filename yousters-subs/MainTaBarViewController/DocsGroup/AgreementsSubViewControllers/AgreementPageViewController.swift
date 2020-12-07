//
//  AgreementPageViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 17.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import Haptica
import StoreKit

class AgreementPageViewController: YoustersStackViewController {
    
    var agreemant:Agreement
    
    let loading = UIAlertController(style: .loading)
    let payButton = YoustersButton(text: "")
    
    var tappedSub:Subscriber?

    init(agreemant:Agreement, type:InitType = .internal_) {
        self.agreemant = agreemant
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        scrollView.contentInset = .init(top: 30, left: 0, bottom: 90, right: 0)
        scrollView.keyboardDismissMode = .onDrag
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 20
        
        switch type {
        case .internal_:
            setupNav()
        case .deepLink:
            addCloseItem()
            setupTitle()
            App.shared.isNeedUpdateDocs = true
            Haptic.notification(.success).generate()
            AgreementService.main.addAgreementToAdded(uid: agreemant.uid) { (res) in
                print("is added \(agreemant.uid) to added - \(res)")
            }
        }
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitle() {
        let title = UILabel(text: agreemant.title, font: Fonts.standart.gilroySemiBoldName(ofSize: 24), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: title)
    }
    
    private func setupNav() {
        navigationItem.title = agreemant.title
        navigationItem.largeTitleDisplayMode = .always
        let barItem = UIBarButtonItem(image: .init(imageLiteralResourceName: "share_doc"), style: .plain, target: self, action: #selector(shareTapped))
        barItem.imageInsets = .init(top: 4, left: 0, bottom: -4, right: 0)
        barItem.tintColor = .bgColor
        
        navigationItem.rightBarButtonItem = barItem
    }
    
    private func setup() {
        
        addInfo(title: agreemant.status.getTitle(), sub: "Статус")
        addInfo(title: agreemant.getFormatedTime(), sub: "Время создания")
        addInfo(title: agreemant.location, sub: "Ссылка на файл", isLink: true)
        addInfo(title: agreemant.serverHash.emojiHash(), sub: "Хэш (SHA256) файла")
        
        guard let user = App.shared.currentUser else {return}
        
        
        switch agreemant.status {
        case .initial:
            
            UserPaketService.main.getMyPaketsAndUsage { (paketAndUsage) in
                if let paketAndUsage = paketAndUsage, paketAndUsage.canUse() {
                    self.addPayOrPaketButton(havePaket: true)
                } else {
                    self.addPayOrPaketButton(havePaket: false)
                    if !user.isValid {
                        self.addInfo(title: "Вы можете оплатить договор, но сможете подписать только после верификации вашего профиля", sub: "Примечание")
                    }
                }
            }
            
        case .paid, .waitKontrAgent, .active:
            if agreemant.status != .paid {
                addSubTitle(title: "Подписали")
            }
            AgreementService.main.getAgreementSubs(uid: agreemant.uid) { (result) in
                print(result)
                var currentUserSubs = false
                for item in result {
                    self.addTitle(title: item.getFormatedString(), spacing: 7)
                    if item.videoUrl != "" {
                        self.addToVideoBut(sub: item)
                    }
                    if item.name == user.name {
                        currentUserSubs = true
                    }
                }
                if currentUserSubs {
                    self.addShareButton()
                } else {
                    if !user.isValid {
                        self.addInfo(title: "Вы сможете подписать только после верификации вашего профиля", sub: "Примечание")
                    }
                    self.addSubButton()
                }
            }
        default:
            break
        }
    }
    
    private func addToVideoBut(sub:Subscriber) {
        let button = ToVideoButton(sub: sub, agr: agreemant, vc: self)
        stackView.addArrangedSubview(button)
    }
    
    private func addPayOrPaketButton(havePaket:Bool) {
        if havePaket {
            payButton.setTitle("Использовать пакет", for: .normal)
            payButton.addTarget(self, action: #selector(usePaket), for: .touchUpInside)
        } else {
            payButton.setTitle("Оплатить и подписать", for: .normal)
            payButton.addTarget(self, action: #selector(toPay), for: .touchUpInside)
        }
        
        view.addSubview(payButton)
        payButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    private func addShareButton () {
        let button = YoustersButton(text: "Поделиться")
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        button.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
    
    private func addSubButton () {
        guard let user = App.shared.currentUser else {
            return
        }
        
        let button = YoustersButton(text: "Подписать")
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        button.addTarget(self, action: #selector(subs), for: .touchUpInside)
        
        if !user.isValid {
            button.isEnabled = false
        }
    }
    
    @objc private func subs() {
        let alert = UIAlertController(style: .loading)
        present(alert, animated: true, completion: nil)
        SubscriptionServive.main.initSubscribe(uid: agreemant.uid) { (result) in
            alert.dismiss(animated: false) {
                print(result)
                if result {
                    let vc = EnterDocsCodeViewController(delegate: self, code: self.agreemant.number)
                    vc.modalPresentationStyle = .popover
                    self.present(vc, animated: false) {
                        vc.present(vc.picker, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func shareTapped() {
        let actionController = UIActivityViewController(activityItems: [URLs.getShare(uid: agreemant.uid)], applicationActivities: nil)
        present(actionController, animated: true, completion: nil)
    }
    
    @objc private func toPay() {
        
        let singlePayID = "com.tommysirenko.yousterssubsapp.single"
        self.present(loading, animated: false, completion: nil)
        fetchProducts(matchingIdentifiers: [singlePayID])
    }
    
    fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)
        
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    @objc private func usePaket() {
        let alert = UIAlertController(style: .loading)
        self.present(alert, animated: true, completion: nil)
        
        AgreementPaketService.main.usePaket(uid: agreemant.uid) { (result, error) in
            alert.dismiss(animated: true) {
                if result {
                    self.agreemant.status = .paid
                    self.reload()
                    App.shared.isNeedUpdateProfile = true
                } else {
                    print(error!)
                    ResponseError.showAlertWithError(vc: self, error: error)
                }
            }
        }
    }
    
    enum InitType {
        case internal_, deepLink
    }    
}

extension AgreementPageViewController: ReloadProtocol {
    func reload() {
        AgreementService.main.getAgreement(uid: agreemant.uid) { (rawAgreement) in
            if let newAgreement = rawAgreement {
                self.agreemant = newAgreement
                self.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
                self.payButton.removeFromSuperview()
                self.setup()
                Haptic.play([.wait(0.3), .haptic(.notification(.success))])
                App.shared.isNeedUpdateDocs = true
            }
        }
    }
}

extension MainDocsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        let mainViewController = self.presentingViewController as? MainDocsViewController
        mainViewController?.getData()
    }
}

extension AgreementPageViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.loading.dismiss(animated: false) {
                if !response.products.isEmpty {
                    if let product = response.products.first {
                        print(product.productIdentifier)
                        self.navigationController?.pushViewController(AgreementPaymentViewController(uid: self.agreemant.uid, page: self, product: product), animated: true)
                    }
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("!!???! \(invalidIdentifier)")
        }
    }
}
