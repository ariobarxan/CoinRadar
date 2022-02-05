//
//  String.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/6/22.
//

import Foundation


extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
