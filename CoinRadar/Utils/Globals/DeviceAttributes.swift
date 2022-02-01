//
//  DeviceAttributes.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/1/22.
//

import SwiftUI



final class DeviceAttributes{
    
    static let instance = DeviceAttributes()
    
    private init(){}
    
    let width  = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
}

