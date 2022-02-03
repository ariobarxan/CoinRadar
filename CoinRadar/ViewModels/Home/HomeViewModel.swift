//
//  HomeViewModel.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject{
    @Published var statisicst:  [Statistic] = []
    @Published var coins:        [Coin]     = []
    @Published var profolioCoin: [Coin]     = []
    @Published var searchString: String     = ""
    private let coinAPIService              = CoinAPIService()
    private let marketAPIService            = MarketAPIService()
    private var cancellables                = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }

    private func addSubscribers(){
        //APIService
        /*
         APIService.$coins
            .sink { [weak self] coins in
                guard let self = self else {return}
                self.coins = coins
            }
            .store(in: &cancellables)
         */
        
        //Search String and APIService combined
        $searchString
            .combineLatest(coinAPIService.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filteredCoins)
            .sink { [weak self] filteredCoins in
                self?.coins = filteredCoins
            }
            .store(in: &cancellables)
        
        
        //Market data
        marketAPIService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statisicst = returnedStats
            }
            .store(in: &cancellables)
    }
    
    private func filteredCoins(text searchString: String, coins: [Coin]) -> [Coin] {
        guard !searchString.isEmpty else {
            return coins
            
        }
        let lowerdCaseSearchString = searchString.lowercased()
        
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowerdCaseSearchString) ||
            coin.symbol.lowercased().contains(lowerdCaseSearchString) ||
            coin.id.lowercased().contains(lowerdCaseSearchString)
        }
    }
    
    private func mapGlobalMarketData(_ data: MarketData?) -> [Statistic]{
        var stats: [Statistic] = []
        
        guard let marketData = data else {return stats}
        
        let marketCap = Statistic(title: "Market Cap", value: marketData.marketCap, percentage: marketData.marketCapChangePercentage24HUsd)
        let volume    = Statistic(title: "24h Volume", value: marketData.volume)
        let btcDom    = Statistic(title: "BTC Dominance", value: marketData.btcDom)
        let portfolio = Statistic(title: "Portfolio Value", value: "$0.00", percentage: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDom,
            portfolio
        ])
        
        return stats
    }
}
