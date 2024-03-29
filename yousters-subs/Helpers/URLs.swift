//
//  URLs.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 12.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation

struct URLs {
    static let host = "you-scribe.ru/"
    static let base = "https://\(host)"
    static let baseAPI = "\(base)api/v1/"
    
    static let baseWS = "wss://\(host)"
    static let baseWSAPI = "\(baseWS)api/v1/"
    
    static func dialogWS(uid:String) -> String {
        "\(baseWSAPI)dialog/\(uid)"
    }
    
    static let auth = "\(baseAPI)auth"
    static let validate = "\(baseAPI)validate"
    static let me = "\(baseAPI)me"
    
    static let sberInit = "\(baseAPI)/sber/init"
    static let sberValidate = "\(baseAPI)/sber/validate"
    
    static let uploadDocsToValid = "\(baseAPI)uploaddocs"
    static let uploadNonPhizData = "\(baseAPI)uploadnonphiz"
    
    static let getAgreements = "\(baseAPI)getagreements"
    static let uploadAgreement = "\(baseAPI)uploadagreement"
    static let getAgreementSubs = "\(baseAPI)getagreementssubs"
    static let initSubscribe = "\(baseAPI)initsubscribe"
    static let validateSubscribe = "\(baseAPI)validatesubscribe"
    
    static let addAgreementToAdded = "\(baseAPI)addagreement"
    
    static let initPayment = "\(baseAPI)payment"
    static let checkPromoCode = "\(baseAPI)promocode"
    static let checkPayment = "\(baseAPI)payment/iap"
    static func getCheckout(uid:String) -> String {
        return "\(baseAPI)checkout/\(uid)"
    }
    
    static let dialogsBase = "\(baseAPI)dialog"
    static let messagesBase = "\(baseAPI)message"
    
    static let reportSubscribe = "\(baseAPI)report/subscribtion"
    
    static let tokenInteract = "\(baseAPI)token"
    
    static let getPakets = "\(baseAPI)pakets"
    static let getMyPaketsAndUsage = "\(getPakets)/my"
    static let usePaket = "\(getPakets)/use"
    
    static func getShare(uid:String) -> URL {
        let shareURL = "\(base)case/\(uid)"
        guard let url = URL(string: shareURL) else {
            return URL(string: base)!
        }
        return url
    }
    
    static func getAgreement(uid:String) -> String {
        "\(baseAPI)getagreement/\(uid)"
    }
    
    static func requisites(inn:String, email:String, token:String) -> String {
        "\(baseAPI)bill?inn=\(inn)&email=\(email)&token=\(token)"
    }
    
    static func getLegal(page:String) -> String {
        "https://you-scribe.ru/legal/\(page)?inapp=true"
    }
}
