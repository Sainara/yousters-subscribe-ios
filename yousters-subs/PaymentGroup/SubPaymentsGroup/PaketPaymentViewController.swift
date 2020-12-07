//
//  PaketPaymentViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import StoreKit

class PaketPaymentViewController: PaymentController {
            
    init(product:SKProduct, page:ReloadProtocol) {
        super.init(product:product, page:page, items: [Item(product:product, amount:1)], type: .paket)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

