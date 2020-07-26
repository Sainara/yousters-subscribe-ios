//
//  PaketPaymentViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class PaketPaymentViewController: PaymentController {
    
    let paket:Paket
        
    init(uid:String, page:ReloadProtocol, paket:Paket) {
        self.paket = paket
        super.init(uid:uid, page:page, items: [.init(title: paket.title, price: Int(paket.getPrice())!, amount: 1)], type: .paket)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func reload() {
        reload_page.reload()
    }
}

