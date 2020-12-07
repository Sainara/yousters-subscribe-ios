//
//  StoreObserver.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 30.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import StoreKit

extension PaymentController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //Handle transaction states here.
        print("I Handle")
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                loading.dismiss(animated: false, completion: nil)
                complete(transaction: transaction)
                break
            case .failed:
                loading.dismiss(animated: false, completion: nil)
                fail(transaction: transaction)
                break
            case .restored:
                loading.dismiss(animated: false, completion: nil)
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                print("purchasing")
            @unknown default:
                break
            }
        }
        
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                print(receiptData)
                
                let receiptString = receiptData.base64EncodedString(options: [])
            
                PaymentService.main.checkPayment(receipt: receiptString, uid: paymentID) { (result) in
                    if result {
                        self.reload()
                    }
                }
            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
        }
        //deliverPurchaseNotificationFor(identifier: transaction.payment)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        
        loading.dismiss(animated: false, completion: nil)
        
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
