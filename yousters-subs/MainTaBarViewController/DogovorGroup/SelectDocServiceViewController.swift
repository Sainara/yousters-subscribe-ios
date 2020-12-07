//
//  SelectDocServiceViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 16.10.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class SelectDocServiceViewController: YoustersStackViewController {
    
    let createButton = YoustersButton(text: "Юрист")
    let auditButton = YoustersButton(text: "Аудит договора (скоро)")
    let constructorButton = YoustersButton(text: "Конструктор договоров (скоро)")

    var actionsGroups:[ActionGroup] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        scrollView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        scrollView.keyboardDismissMode = .onDrag
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 20
        
        bottomPaddinng = 20
        bottomOffset = -20
        
        createButton.setOnTapAction {
            self.navigationController?.pushViewController(CreateDialogViewController(type: .create), animated: true)
        }
        
        constructorButton.isEnabled = false
        auditButton.isEnabled = false
        
        let createGroup = [createButton, constructorButton]
        let anotherGroup = [auditButton]
        
        actionsGroups.append(ActionGroup(title: "Создать договор", actions: createGroup, order: 1))
        actionsGroups.append(ActionGroup(title: "Аудит", actions: anotherGroup, order: 2))
        
        actionsGroups.sort()
        
        setup()
        
        navigationItem.title = "Выберите услугу"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        for group in actionsGroups {
            let title = UILabel(text: group.title, font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .bgColor, textAlignment: .left, numberOfLines: 0)
            addWidthArrangedSubView(view: title, spacing: 10)
            for action in group.actions {
                addWidthArrangedSubView(view: action)
            }
        }
    }
}

struct ActionGroup: Comparable {
    var title:String, actions:[YoustersButton], order:Int
    
    static func < (lhs: ActionGroup, rhs: ActionGroup) -> Bool {
        lhs.order < rhs.order
    }
}
