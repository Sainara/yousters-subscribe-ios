//
//  YoustersWKWebViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import WebKit

class YoustersWKWebViewController: YoustersViewController {
    
    let webView = WKWebView()
    
    init(url:String) {
        super.init(nibName: nil, bundle: nil)
        setupView()
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
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

