//
//  YoustersComponentView.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 14.11.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import UIKit

class YoustersComponentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func centered(xOffset:CGFloat = 0, yOffset:CGFloat = 0) {
        snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(xOffset)
            make.centerY.equalToSuperview().offset(yOffset)
        }
    }
}
