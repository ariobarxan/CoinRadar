//
//  CloseButton.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/4/22.
//

import SwiftUI

struct CloseButton: View {
    var body: some View {
        Label(title: {Text("Close Button")}) {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton()
    }
}
