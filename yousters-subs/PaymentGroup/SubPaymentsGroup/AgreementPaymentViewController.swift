//
//  AgreementPaymentViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 24.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class AgreementPaymentViewController: PaymentController {
    
    let agr_page:AgreementPageViewController
    
    init(uid:String, page:AgreementPageViewController) {
        self.agr_page = page
        super.init(uid:uid, page:page, items: [.init(title: "Разовое подписание", price: 49, amount: 1)], type: .agreement)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reload() {
        agr_page.agreemant.status = .paid
        agr_page.reload()
    }
}
