//
//  Errors.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import Foundation

enum NetworkingError: LocalizedError{
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String?{
        switch self {
        case .badURLResponse(url: let url):
            return "[Networking Error] Bad response from url: \(url)"
        case .unknown:
            return "[Networking Error] Unknown error occured "
        }
    }
}
