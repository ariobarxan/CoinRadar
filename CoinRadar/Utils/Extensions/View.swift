//
//  View.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/1/22.
//

import SwiftUI

extension View {
    public func frame(size: CGFloat, alignment: Alignment = .center) -> some View{
        modifier(Frame(size: size, alignment: alignment))
    }
}
