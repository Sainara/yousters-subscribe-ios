//
//  DocumentServicePaymentViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 22.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import UIKit

class DocumentServicePaymentViewController: PaymentController {
    
    let offerUID:String
    
    init(offerUID:String, items:[Item], page:ReloadProtocol?) {
        self.offerUID = offerUID
        
        super.init(page:page, items: items, type: .documentService)
        
        //scrollView.bounces = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pay() {
        PaymentService.main.initPayment(type: type, uid: offerUID, promoCode: promoCodeValue) { (result) in

            guard let uid = result else {
                self.loading.dismiss(animated: false, completion: nil)
                let error = UIAlertController(style: .errorMessage)
                self.present(error, animated: false, completion: nil)
                return
            }

            self.paymentID = uid
            print(uid)
            
            let checkout = CheckoutViewController(url: URLs.getCheckout(uid: uid), parentVC: self)
            checkout.modalPresentationStyle = .popover
            self.present(checkout, animated: true, completion: nil)

        }
    }
}
