//
//  SelectOrgTypeViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 13.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class SelectOrgTypeViewController: YoustersStackViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        //bottomOffset = -210
        //bottomPaddinng = 15
        
        scrollView.contentInset = .init(top: view.frame.height/3, left: 0, bottom: 90, right: 0)
        stackView.distribution = .equalSpacing
        //scrollView.keyboardDismissMode = .onDrag
        stackView.spacing = 20.0
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        
        let infoLabel = UILabel(text: "Выберите тип профиля", font: Fonts.standart.gilroyMedium(ofSize: 22), textColor: .bgColor, textAlignment: .center, numberOfLines: 0)
        addWidthArrangedSubView(view: infoLabel)

        let phis = YoustersButton(text: "Физ. лицо")
        phis.addTarget(self, action: #selector(phizClick), for: .touchUpInside)
        addWidthArrangedSubView(view: phis)
        
        let ipOrOOO = YoustersButton(text: "ИП или Юр. лицо")
        ipOrOOO.addTarget(self, action: #selector(nonPhizClick), for: .touchUpInside)
        addWidthArrangedSubView(view: ipOrOOO)
        
        let logOutButton = YoustersButton(text: "Выйти")
        view.addSubview(logOutButton)
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        
        logOutButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    @objc private func phizClick() {
        let phizNext = EnterValidateDataViewController()
        //let phizNext = SelectPhizAuthViewController()
        phizNext.modalPresentationStyle = .popover
        self.present(phizNext, animated: true, completion: nil)
    }
    
    @objc private func nonPhizClick() {
        let nonPhizNext = NonPhizValidationViewController()
        nonPhizNext.modalPresentationStyle = .popover
        self.present(nonPhizNext, animated: true, completion: nil)
    }
    
    @objc private func logOut() {
        App.shared.logOut(topController: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
