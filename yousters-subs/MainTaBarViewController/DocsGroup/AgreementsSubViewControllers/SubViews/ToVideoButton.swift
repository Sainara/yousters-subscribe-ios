//
//  ToVideoButton.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 31.08.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit

class ToVideoButton: YoustersButton {
    
    let sub:Subscriber
    let agr:Agreement
    unowned let vc:UIViewController
    
    init(sub:Subscriber, agr:Agreement, vc:UIViewController) {
        self.vc = vc
        self.agr = agr
        self.sub = sub
        super.init()
        
        self.setup(text: "Видео", size: 16, height: 30, style: .basic)
        
        addTarget(self, action: #selector(toVideoVC), for: .touchUpInside)
        
        snp.makeConstraints { (make) in
            make.width.equalTo(150)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toVideoVC() {
        let to = SubscriptionVideoPageViewController(sub: sub, agr: agr)
        vc.present(to, animated: true, completion: nil)
    }
}
