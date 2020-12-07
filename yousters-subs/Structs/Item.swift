//
//  Item.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 22.10.2020.
//  Copyright © 2020 tommy. All rights reserved.
//

import StoreKit

struct Item {
    var title:String, price:Int, amount:Int
    
    init(product:SKProduct, amount:Int) {
        title = product.localizedTitle
        price = Int(product.price.description(withLocale: Locale(identifier: "ru"))) ?? 0
        self.amount = amount
    }
    
    init(title:String, price:Int, amount:Int) {
        self.title = title
        self.price = price
        self.amount = amount
    }
}
