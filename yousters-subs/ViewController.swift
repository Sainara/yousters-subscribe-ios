//
//  ViewController.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 08.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        
        let but = YoustersButton(text: "AAAAAAAAAAAAAAAA")
        view.addSubview(but)
        but.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
        }
        
        let but2 = YoustersButton(text: "AAAAAAAAAAAAAAAA")
        view.addSubview(but2)
        but2.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
        }
        
        navigationItem.title = "Главная"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

