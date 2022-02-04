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
    @Published var isLoading:    Bool       = false
    private let coinAPIService              = CoinAPIService()
    private let marketAPIService            = MarketAPIService()
    private let portfolioCDService          = PortfolioDataService()
    private var cancellables                = Set<AnyCancellable>()
    
    
    
    init(){
        addSubscribers()
    }

    private func addSubscribers(){
        
        //Search String and APIService combined
        $searchString
            .combineLatest(coinAPIService.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filteredCoins)
            .sink { [weak self] filteredCoins in
                self?.coins = filteredCoins
            }
            .store(in: &cancellables)
        
        
        
        //Portfolio Coins
        $coins
            .combineLatest(portfolioCDService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoin)
            .sink { [weak self] returnedCoins in
                self?.profolioCoin = returnedCoins
            }
            .store(in: &cancellables)
        
        
        
        //Market data
        marketAPIService.$marketData
            .combineLatest($profolioCoin)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statisicst = returnedStats
                self?.isLoading  = false
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
    private func mapGlobalMarketData(_ data: MarketData?, portfolioCoin: [Coin]) -> [Statistic]{
        var stats: [Statistic] = []
        
        guard let marketData = data else {return stats}
        
        let marketCap      = Statistic(title: "Market Cap", value: marketData.marketCap, percentage: marketData.marketCapChangePercentage24HUsd)
        
        
        let volume         = Statistic(title: "24h Volume", value: marketData.volume)
        let btcDom         = Statistic(title: "BTC Dominance", value: marketData.btcDom)
        
        
        let portfolioValue   = portfolioCoin.map({$0.currentHoldingsValue}).reduce(0, +)
        let previousValue    = portfolioCoin.map { coin -> Double in
            let currentValue  = coin.currentHoldingsValue
            let percentChnage = coin.priceChangePercentage24H ?? 0 / 100
            let previousValue = currentValue / (1 + percentChnage)
            
            return previousValue
        }.reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio      = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentage: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDom,
            portfolio
        ])
        
        return stats
    }
    private func mapAllCoinsToPortfolioCoin(coins: [Coin], portfolioCoins portfolioEntities: [PortfolioEntity]) -> [Coin]{
        coins
            .compactMap { coin -> Coin? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {return nil}
                
                return coin.updateHoldings(amount: entity.amountHolding)
            }

    }
    
    func updatePortfolio(coin: Coin, amount amountHolding: Double){
        portfolioCDService.updatePortfolio(coinID: coin.id, amount: amountHolding)
    }
    func reloadData(){
        self.isLoading = true
        coinAPIService.downloadCoins()
        marketAPIService.downloadMarketData()
        HapticManager.notification(type: .success)
    }
}
