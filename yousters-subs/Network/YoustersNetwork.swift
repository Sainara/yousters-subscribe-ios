//
//  YoustersNetwork.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 22.07.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Alamofire


class YoustersNetwork {
    
    func getHTTPHeaders(rawHeaders:[HTTPHeaderType]) -> HTTPHeaders? {
        
        var headers = HTTPHeaders()
        
        for rawHeader in rawHeaders {
            if let header = rawHeader.initHeader() {
                headers.add(header)
            } else {
                return nil
            }
        }

        return headers
    }

    let basicHeaders:[HTTPHeaderType] = [.token, .accept]

    enum HTTPHeaderType {
        case token, accept

        func initHeader() -> HTTPHeader? {
            switch self {
            case .accept:
                return HTTPHeader.accept("application/json")
            case .token:
                guard let token = App.shared.token else {return nil}
                return HTTPHeader.init(name: "token", value: token)
            }
        }
    }
}
