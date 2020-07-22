//
//  ProfileViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 15.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class ProfileViewController: YoustersStackViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        scrollView.contentInset = .init(top: 20, left: 0, bottom: 100, right: 0)
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        navigationItem.title = "Профиль"
        navigationItem.largeTitleDisplayMode = .always
        
        guard let user = App.shared.currentUser else {
            addLogOut()
            return
        }
        if user.isOnValidation {
            setupViewWithState(state: .onValidation)
        }
        if user.isValid {
            setupViewWithState(state: .active)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewWithState(state:ProfileState) {
        switch state {
        case .onValidation:
            setupOnValidation()
        case .active:
            setupValidated()
        }
        addFAQ()
        addLinks()
        addLogOut()
    }
    
    private func addFAQ() {
        let faq = YoustersButton(text: "FAQ", style: .secondary)
        addWidthArrangedSubView(view: faq)
        let support = YoustersButton(text: "Служба поддержки", style: .secondary)
        addWidthArrangedSubView(view: support, spacing: 60)
    }
    
    private func addLinks() {
        let userAgre = YoustersButtonLink(link: "https://you-scribe.ru/legal/user-agreement", fontSize: 17, title: "Лицензионное соглашение")
        addWidthArrangedSubView(view: userAgre)
        let terms = YoustersButtonLink(link: "https://you-scribe.ru/legal/termsofuse", fontSize: 17, title: "Условия использования")
        addWidthArrangedSubView(view: terms)
        let policy = YoustersButtonLink(link: "https://you-scribe.ru/legal/confidential", fontSize: 17, title: "Политика конфиденциальности")
        addWidthArrangedSubView(view: policy)
    }
    
    private func setupValidated() {
        guard let user = App.shared.currentUser else {return}
        
        let nameLabel = UILabel(text: user.name, font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(nameLabel)
        
        addTitle(title: user.inn, subTitle: "ИНН")
        addTitle(title: user.email, subTitle: "Email")
        
        addTitle(title: "Отсутсвует", subTitle: "Пакет")
        
    }
    
    private func setupOnValidation() {
        guard let user = App.shared.currentUser else {return}
        
        let phoneLabel = UILabel(text: user.phone, font: Fonts.standart.gilroySemiBoldName(ofSize: 40), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(phoneLabel)
        
        let infoLabel = UILabel(text: "Ваш профиль находится на верификации. Вам придёт оповещение, когда мы закончим", font: Fonts.standart.gilroyRegular(ofSize: 17), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        stackView.addArrangedSubview(infoLabel)
    }
    
    private func addLogOut() {
        let but = YoustersButton(text: "Выйти")
        view.addSubview(but)
        but.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
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
    
    @objc private func logOut() {
        App.shared.logOut(topController: self)
    }
    
    enum ProfileState {
        case onValidation, active
    }
}

