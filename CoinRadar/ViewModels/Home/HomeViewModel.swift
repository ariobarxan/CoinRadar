//
//  HomeViewModel.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject{
    @Published var coins: [Coin]        = []
    @Published var profolioCoin: [Coin] = []
    
    private let APIService = CoinAPIService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }

    private func addSubscribers(){
        APIService.$coins
            .sink { [weak self] coins in
                guard let self = self else {return}
                self.coins = coins
            }
            .store(in: &cancellables)
    }
}
