//
//  LoadingView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 14.11.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import UIKit

class LoadingView: YoustersComponentView {
    
    let activityView = UIActivityIndicatorView(style: .gray)

    init() {
        super.init(frame: .zero)
        
        addSubview(activityView)
        activityView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        activityView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
