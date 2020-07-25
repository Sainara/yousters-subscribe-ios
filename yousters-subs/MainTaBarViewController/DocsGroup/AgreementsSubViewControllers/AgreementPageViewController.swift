//
//  AgreementPageViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 17.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import PassKit

class AgreementPageViewController: YoustersStackViewController {
    
    var agreemant:Agreement

    init(agreemant:Agreement, type:InitType = .internal_) {
        self.agreemant = agreemant
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        scrollView.contentInset = .init(top: 30, left: 0, bottom: 0, right: 0)
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
            let payButton = YoustersButton(text: "Оплатить и подписать")
            view.addSubview(payButton)
            payButton.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
            payButton.addTarget(self, action: #selector(toPay), for: .touchUpInside)
            if !user.isValid {
                addInfo(title: "Вы можете оплатить договор, но сможете подписать только после верификации вашего профиля", sub: "Примечание")
            }
        case .paid, .waitKontrAgent, .active:
            addSubTitle(title: "Подписали")
            AgreementService.main.getAgreementSubs(uid: agreemant.uid) { (result) in
                print(result)
                var currentUserSubs = false
                for item in result {
                    self.addTitle(title: item.getFormatedString())
                    if item.inn == user.inn {
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
    
    private func addInfo(title:String, sub:String, isLink:Bool = false) {
        addSubTitle(title: sub)
        if isLink {
            let linkBut = YoustersButtonLink(link: title, fontSize: 18, isUnderLined: true)
            linkBut.contentHorizontalAlignment = .leading
            addWidthArrangedSubView(view: linkBut)
        } else {
           addTitle(title: title)
        }
    }
    
    private func addTitle(title:String) {
        let label = UILabel(text: title, font: Fonts.standart.gilroyMedium(ofSize: 18), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: label)
    }
    
    private func addSubTitle(title:String) {
        let label = UILabel(text: title, font: Fonts.standart.gilroyRegular(ofSize: 15), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: label, spacing: 5)
    }
    
    @objc private func subs() {
        let alert = UIAlertController(style: .loading)
        present(alert, animated: true, completion: nil)
        SubscriptionServive.main.initSubscribe(uid: agreemant.uid) { (result) in
            alert.dismiss(animated: false) {
                print(result)
                if result {
                    let vc = EnterDocsCodeViewController(delegate: self)
                    vc.modalPresentationStyle = .popover
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func shareTapped() {
        let actionController = UIActivityViewController(activityItems: [URLs.getShare(uid: agreemant.uid)], applicationActivities: nil)
        present(actionController, animated: true, completion: nil)
    }
    
    @objc private func toPay() {
        navigationController?.pushViewController(AgreementPaymentViewController(uid: agreemant.uid, page: self), animated: true)
    }
    
    enum InitType {
        case internal_, deepLink
    }
    
}

extension AgreementPageViewController: ReloadProtocol {
    func reload() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        setup()
        App.shared.isNeedUpdateDocs = true
    }
}

extension MainDocsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        let mainViewController = self.presentingViewController as? MainDocsViewController
        mainViewController?.getData()
    }
}
