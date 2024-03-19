//
//  CoinRepository.swift
//  CoinRadar
//
//  Created by Home on 19/3/2024.
//

import Foundation
import Combine

protocol CoinAPIRepositoryProtocol: ObservableObject {
    var coins: [Coin] {get set}
    func getCoins()
}

final class CoinAPIRepository: CoinAPIRepositoryProtocol {
    @Published var coins: [Coin] = []
    private var subscription: AnyCancellable?
    private let coinAPIService = CoinAPIService()
    
    init() {
        addSubscriber()
        getCoins()
    }
    
    func getCoins() {
        coinAPIService.downloadCoins()
    }
    
    private func addSubscriber() {
         subscription = coinAPIService.$coins
            .sink { [weak self] returnedCoins  in
                guard let self = self else { return }
                
                self.coins = returnedCoins
            }
    }
}
