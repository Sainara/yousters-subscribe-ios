//
//  Paket.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import SwiftyJSON
import StoreKit

struct Paket {
    var id:String, title:String, description:String, price:String, howMuch:Int, iapID:String?
    
    init(data:JSON) {
        id = data["id"].stringValue
        title = data["title"].stringValue
        description = data["description"].stringValue
        price = data["price"].stringValue
        howMuch = data["howmuch"].intValue
        iapID = data["iap_id"].stringValue
    }
    
    init(id:String, title:String, description:String, price:String, howMuch:Int) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.howMuch = howMuch
    }
    
    init(product:SKProduct) {
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.localizedDescription + ",Каждый последующий документ тарифицируется как разовый ,Входящие документы бесплатно"
        self.price = product.price.description(withLocale: Locale(identifier: "ru_RU"))
        self.howMuch = 10
    }
    
    func getShortTitle() -> String {
        String(title.prefix(upTo: title.firstIndex(of: " ") ?? title.endIndex))
    }
    
    func getPrice() -> String {
        String(price.prefix(upTo: price.firstIndex(of: ".") ?? price.endIndex))
    }
    
    func getDesc() -> String {
        return description.replacingOccurrences(of: ",", with: "\n")
    }
}

struct PaketsAndUsage {
    let pakets:[Paket]
    let usage:Int
    
    init(data:JSON) {
        var packets = [Paket]()
        for item in data["packets"].arrayValue {
            packets.append(Paket(data: item))
        }
        self.pakets = packets
        self.usage = data["usage"].intValue
    }
    
    func totalPaket() -> Int {
        var total = 0
        pakets.forEach({total += $0.howMuch})
        return total
    }
    
    func canUse() -> Bool {
        totalPaket() > usage
    }
}
