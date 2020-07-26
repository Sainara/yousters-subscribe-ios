//
//  Paket.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 26.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import SwiftyJSON

struct Paket {
    var id:Int, title:String, description:String, price:String, howMuch:Int
    
    init(data:JSON) {
        id = data["id"].intValue
        title = data["title"].stringValue
        description = data["description"].stringValue
        price = data["price"].stringValue
        howMuch = data["howmuch"].intValue
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
