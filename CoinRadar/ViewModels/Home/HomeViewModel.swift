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
    @Published var sortOption:   SortOption = .holdings
    private let coinAPIService              = CoinAPIService()
    private let marketAPIService            = MarketAPIService()
    private let portfolioCDService          = PortfolioDataService()
    private var cancellables                = Set<AnyCancellable>()
    
   
    
    init(){
        addSubscribers()
    }

    private func addSubscribers(){
        
        ///Search String and APIService combined -> Update coins base on search and sort option
        $searchString
            .combineLatest(coinAPIService.$coins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] filteredCoins in
                self?.coins = filteredCoins
            }
            .store(in: &cancellables)
        
        
        
        ///Portfolio Coins
        $coins
            .combineLatest(portfolioCDService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoin)
            .sink { [weak self] returnedCoins in
                guard let self = self else {return}
                self.profolioCoin = self.sortPortfolioCoinIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        
        
        ///Market data
        marketAPIService.$marketData
            .combineLatest($profolioCoin)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statisicst = returnedStats
                self?.isLoading  = false
            }
            .store(in: &cancellables)
    }
    private func filterAndSortCoins(searchString: String, coins: [Coin], sort sortOption: SortOption) -> [Coin]{
        ///Filter
        var updatedCoins = filteredCoins(text: searchString, coins: coins)
        
        ///Sort
        sortCoins(sortOption, coins: &updatedCoins)
        
        return updatedCoins
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
    private func sortCoins(_ sortOption: SortOption, coins: inout [Coin]){
        switch sortOption{
            case .rank, .holdings:
                coins.sort{$0.rank < $1.rank}
            case .rankReversed, .holdingsReversed:
                coins.sort{$0.rank > $1.rank}
            case .price:
                coins.sort{$0.currentPrice > $1.currentPrice}
            case .priceReversed:
                coins.sort{$0.currentPrice < $1.currentPrice}
        }
    }
    private func sortPortfolioCoinIfNeeded(coins: [Coin]) -> [Coin]{
       ///Only sort by holding or holdingReverser
        switch sortOption{
            case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
            case .holdingsReversed:
                return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
            
            default:
                return coins
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
