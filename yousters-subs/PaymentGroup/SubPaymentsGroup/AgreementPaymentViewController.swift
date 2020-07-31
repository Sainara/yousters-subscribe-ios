//
//  AgreementPaymentViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 24.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import StoreKit

class AgreementPaymentViewController: PaymentController {
    
    let agr_page:AgreementPageViewController
    
    init(uid:String, page:AgreementPageViewController, product: SKProduct) {
        self.agr_page = page
        super.init(product: product, page:page, items: [.init(product: product, amount: 1)], type: .agreement)
        self.agreementID = uid
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reload() {
        navigationController?.popViewController(animated: true)
        agr_page.agreemant.status = .paid
        agr_page.reload()
    }
}
