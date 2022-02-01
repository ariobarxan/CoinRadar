//
//  HomeViewModel.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import SwiftUI

final class HomeViewModel: ObservableObject{
    @Published var coins: [Coin]        = []
    @Published var profolioCoin: [Coin] = []
    
    
    init(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.coins.append(DeveloperPreview.instance.coin)
            self.profolioCoin.append(DeveloperPreview.instance.coin)
        }
    }
}
