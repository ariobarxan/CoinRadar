//
//  MarketAPIRepository.swift
//  CoinRadar
//
//  Created by Home on 19/3/2024.
//

import Foundation
import Combine

protocol MarketAPIRepositoryProtocol: ObservableObject {
    var marketData: MarketData? {get set}
    func getMarketData()
}

final class MarketAPIRepository: MarketAPIRepositoryProtocol {
    @Published var marketData: MarketData? = nil
    private var subscription: AnyCancellable?
    private let marketAPIService = MarketAPIService()
    
    init() {
        addSubscriber()
        getMarketData()
    }
    
    func getMarketData() {
        marketAPIService.downloadMarketData()
    }
    
    private func addSubscriber() {
        subscription = marketAPIService.$marketData
            .sink { [weak self] returnedMarketData  in
                guard let self = self else { return }
                
                self.marketData = returnedMarketData
            }
    }
}
