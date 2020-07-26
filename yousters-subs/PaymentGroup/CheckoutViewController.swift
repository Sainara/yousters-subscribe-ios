//
//  CheckoutViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 14.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import WebKit

class CheckoutViewController: YoustersViewController {
    
    let webView = WKWebView()
    let parentVC:PaymentController

    init(url:String, parentVC:PaymentController) {
        self.parentVC = parentVC
        super.init(nibName: nil, bundle: nil)
        setupView()
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.navigationDelegate = self
        webView.load(myRequest)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.addSubview(webView)
        addCloseItem()
        view.backgroundColor = .white
        webView.fillSuperview(padding: .init(top: 50, left: 0, bottom: 0, right: 0 ))
    }

}

// MARK: Tinkoff CheckOut

extension CheckoutViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.absoluteStringByTrimmingQuery() == "https://you-scribe.ru/api/v1/checkout/success" {
            self.dismiss(animated: true) {
                self.parentVC.navigationController?.popViewController(animated: true)
                self.parentVC.reload()
            }
        }
        decisionHandler(.allow)
    }
}



// MARK: Yandex.CheckOut
//
//extension CheckoutViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let url = webView.url, url.absoluteString == "https://you-scribe.ru/api/v1/checkout/success" {
//            print("111111 \(parentVC)")
//            self.dismiss(animated: true) {
//                self.parentVC.navigationController?.popViewController(animated: true)
//                self.parentVC.agr_page.agreemant.status = .paid
//                self.parentVC.agr_page.reload()
//            }
//        }
//        decisionHandler(.allow)
//    }
//}
//
