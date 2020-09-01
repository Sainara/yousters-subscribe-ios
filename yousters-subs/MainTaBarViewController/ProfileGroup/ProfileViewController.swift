//
//  ProfileViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 15.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import StoreKit
import Haptica

class ProfileViewController: YoustersStackViewController {
    
    let collectionView = PaketsCollectionView(pakets: [])
    let but = YoustersButton(text: "Выйти")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if App.shared.isNeedUpdateProfile {
            reload()
            App.shared.isNeedUpdateProfile = false
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        navigationItem.title = "Профиль"
        navigationItem.largeTitleDisplayMode = .always
        
        initView()
        
    }
    
    func initView() {
        guard let user = App.shared.currentUser else {
            addLogOut(state: .onValidation)
            return
        }
        if user.isOnValidation {
            setupViewWithState(state: .onValidation)
            return
        }
        if user.isValid {
            setupViewWithState(state: .active)
            return
        }
        setupViewWithState(state: .notOnValidation)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewWithState(state:ProfileState) {
        switch state {
        case .notOnValidation:
            setupNotOnValidation()
            scrollView.contentInset = .init(top: 20, left: 0, bottom: 100, right: 0)
        case .onValidation:
            setupOnValidation()
            scrollView.contentInset = .init(top: 20, left: 0, bottom: 100, right: 0)
        case .active:
            setupValidated()
            addPakets()
            scrollView.contentInset = .init(top: 20, left: 0, bottom: 40, right: 0)
        }
        addFAQ()
        addLinks()
        addLogOut(state: state)
    }
    
    private func addPakets() {
    
        collectionView.parentVC = self
        addWidthArrangedSubView(view: collectionView, spacing: 20, offsets: 0)
        
        UserPaketService.main.getPakets { (pakets) in
            var ids = [String]()
            pakets.forEach({
                if let id = $0.iapID {
                    ids.append(id)
                }
            })
            print(ids)
            self.fetchProducts(matchingIdentifiers: ids)
        }
    }
    
    fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)
        
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    private func addFAQ() {
        let faq = YoustersButton(text: "FAQ", style: .secondary)
        addWidthArrangedSubView(view: faq)
        faq.addTarget(self, action: #selector(openFAQ), for: .touchUpInside)
        let support = YoustersButton(text: "Служба поддержки", style: .secondary)
        addWidthArrangedSubView(view: support, spacing: 60)
        support.addTarget(self, action: #selector(openSupport), for: .touchUpInside)
    }
    
    private func addLinks() {
        let userAgre = YoustersButtonLink(link: URLs.getLegal(page: "user-agreement"), fontSize: 17, title: "Лицензионное соглашение", vc: self)
        addWidthArrangedSubView(view: userAgre)
        let terms = YoustersButtonLink(link: URLs.getLegal(page: "termsofuse"), fontSize: 17, title: "Условия использования", vc: self)
        addWidthArrangedSubView(view: terms)
        let policy = YoustersButtonLink(link: URLs.getLegal(page: "confidential"), fontSize: 17, title: "Политика конфиденциальности", vc: self)
        addWidthArrangedSubView(view: policy, spacing: 40)
    }
    
    private func setupValidated() {
        guard let user = App.shared.currentUser else {return}
        
        let nameLabel = UILabel(text: user.name, font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: nameLabel)
        
        if !(user.isPhiz ?? true) {
            addTitle(title: user.inn, subTitle: "ИНН")
        }
        addTitle(title: user.email, subTitle: "Email")
        
        setUpUserPaketInfo()
        //addTitle(title: "Отсутсвует", subTitle: "Пакет")
        
    }
    
    private func setupNotOnValidation() {
        guard let user = App.shared.currentUser else {return}
        
        let phoneLabel = UILabel(text: user.phone, font: Fonts.standart.gilroySemiBoldName(ofSize: 40), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(phoneLabel)
        
        let support = YoustersButton(text: "Пройти верификацию")
        addWidthArrangedSubView(view: support)
        support.addTarget(self, action: #selector(goToVerificatino), for: .touchUpInside)
        
        let infoLabel = UILabel(text: "Вы можете пройти верификацию, чтобы иметь возможность подписывать договоры", font: Fonts.standart.gilroyRegular(ofSize: 17), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(infoLabel)
        
    }
    
    private func setupOnValidation() {
        guard let user = App.shared.currentUser else {return}
        
        let phoneLabel = UILabel(text: user.phone, font: Fonts.standart.gilroySemiBoldName(ofSize: 40), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(phoneLabel)
        
        let infoLabel = UILabel(text: "Ваш профиль находится на верификации. Вам придёт оповещение, когда мы закончим", font: Fonts.standart.gilroyRegular(ofSize: 17), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(infoLabel)
        
        
        guard let inn = user.inn, let email = user.email, let isPhiz = user.isPhiz, !isPhiz,
            let token = App.shared.token else {return}
        let billUrl = URLs.requisites(inn: inn, email: email, token: token)
        let toBill = YoustersButtonLink(link: billUrl, title: "Счет на оплату, если еще не оплатили", isUnderLined: true)
        addWidthArrangedSubView(view: toBill)
    }
    
    private func addLogOut(state:ProfileState) {
        
        switch state {
        case .notOnValidation:
            view.addSubview(but)
            but.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
        case .active:
            addWidthArrangedSubView(view: but)
        case .onValidation:
            view.addSubview(but)
            but.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
        }
        but.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
    private func addTitle(title:String?, subTitle:String) {
        addSubTitle(subTitle: subTitle)
        let label = UILabel(text: title, font: Fonts.standart.gilroyMedium(ofSize: 20), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: label)
    }
    
    private func addSubTitle(subTitle:String) {
        let label = UILabel(text: subTitle, font: Fonts.standart.gilroyMedium(ofSize: 16), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: label, spacing: 0)
    }
    
    @objc private func goToVerificatino() {
        let vc = SelectOrgTypeViewController()
        vc.reloadProtocol = self
        vc.addCloseItem(addFromSuper: true)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func logOut() {
        App.shared.logOut(topController: self)
    }
    
    @objc private func openFAQ() {
        let link = URLs.getLegal(page: "faq")
        
        let webVC = YoustersWKWebViewController(url: link)
        webVC.modalPresentationStyle = .popover
        parent?.present(webVC, animated: true, completion: nil)
    }
    
    @objc private func openSupport() {
        let email = "support@you-scribe.ru"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func setUpUserPaketInfo() {
        let wrap = UIView()
        wrap.backgroundColor = .secondaryButtonColor
        wrap.layer.cornerRadius = 8
        wrap.clipsToBounds = true
        addWidthArrangedSubView(view: wrap)
        
        let note = UILabel(text: "Расход пакетов:", font: Fonts.standart.gilroyMedium(ofSize: 18), textColor: .bgColor, textAlignment: .left, numberOfLines: 1)
        wrap.addSubview(note)
        note.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        let data = UILabel(text: "-/-", font: Fonts.standart.gilroySemiBoldName(ofSize: 17), textColor: .bgColor, textAlignment: .right, numberOfLines: 1)
        wrap.addSubview(data)
        data.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        UserPaketService.main.getMyPaketsAndUsage { (result) in
            if let result = result {
                if result.pakets.isEmpty {
                    data.text = "Пусто"
                } else {
                    data.font = Fonts.standart.gilroyMedium(ofSize: 23)
                    data.text = "\(result.usage)/\(result.totalPaket())"
                }
            } else {
                data.text = "Неизвестно"
            }
        }
    }
    
    enum ProfileState {
        case notOnValidation, onValidation, active
    }
}

extension ProfileViewController: ReloadProtocol {
    func reload() {
        AuthService.main.me { (user, isNeedLogOut) in
            if isNeedLogOut {
                App.shared.logOut()
                return
            }
            self.but.removeFromSuperview()
            self.stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
            self.initView()
            Haptic.play([.wait(0.1), .haptic(.notification(.success))])
        }
    }
}

extension ProfileViewController: ParentViewControllerProtocol {
    func workWithData(data: Any) {
        if let paket = data as? SKProduct {
            let paymentVC = PaketPaymentViewController(product:paket, page: self)
            navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
}

extension ProfileViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
         print("products")
        if !response.products.isEmpty {
            let products = response.products
            print(products)
            DispatchQueue.main.async {
                self.collectionView.pakets = products.sorted(by: { (l, r) -> Bool in
                    l.price.doubleValue < r.price.doubleValue
                })
                self.collectionView.reloadData()
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("!!???! \(invalidIdentifier)")
        }
    }
}
