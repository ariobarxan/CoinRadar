//
//  Frame.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/1/22.
//

import SwiftUI

struct Frame: ViewModifier{
    
    let size: CGFloat
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size, alignment: alignment)
    }
}
