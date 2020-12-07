//
//  YoustersStackViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SnapKit

class YoustersStackViewController: YoustersViewController {
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            bottomConstraint = make.bottom.equalTo(view.snp.bottom).offset(bottomOffset).constraint
        }
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        containerView.backgroundColor = .clear
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let containerViewConsts = [containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 0),
                                   containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
                                   containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 0),
                                   containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: 0),
                                   containerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1)
        ]
        NSLayoutConstraint.activate(containerViewConsts)
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let licViewConsts = [stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
                             stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
                             stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
                             stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(licViewConsts)
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 15.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        //stackView.addGestureRecognizer(tap)
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc private func tapped() {
        view.endEditing(true)
    }
    
    func addWidthArrangedSubView(view:UIView, spacing:CGFloat? = nil, offsets:CGFloat = 20) {
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(offsets)
            make.trailing.equalToSuperview().offset(-offsets)
        }
        if let space = spacing {
            stackView.setCustomSpacing(space, after: view)
        }
    }
    
    override func addCloseItem(addFromSuper:Bool = false) {
        if addFromSuper {
            super.addCloseItem()
        } else {
            let close = UIButton(title: "Закрыть", titleColor: .bgColor)
            close.titleLabel?.font = Fonts.standart.gilroyMedium(ofSize: 15)
            close.contentHorizontalAlignment = .trailing
            close.addTarget(self, action: #selector(closeMe), for: .touchUpInside)
            addWidthArrangedSubView(view: close)
        }
    }
    
    func addInfo(title:String, sub:String, isLink:Bool = false) {
        addSubTitle(title: sub)
        if isLink {
            let linkBut = YoustersButtonLink(link: title, fontSize: 18, isUnderLined: true)
            linkBut.contentHorizontalAlignment = .leading
            addWidthArrangedSubView(view: linkBut)
        } else {
           addTitle(title: title)
        }
    }
    
    func addTitle(title:String, spacing:CGFloat? = nil) {
        let label = UILabel(text: title, font: Fonts.standart.gilroyMedium(ofSize: 18), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
        if let spacing = spacing {
            addWidthArrangedSubView(view: label, spacing: spacing)
        } else {
            addWidthArrangedSubView(view: label)
        }
        
    }
    
    func addSubTitle(title:String) {
        let label = UILabel(text: title, font: Fonts.standart.gilroyRegular(ofSize: 15), textColor: .blackTransp, textAlignment: .left, numberOfLines: 0)
        addWidthArrangedSubView(view: label, spacing: 5)
    }
    
}
