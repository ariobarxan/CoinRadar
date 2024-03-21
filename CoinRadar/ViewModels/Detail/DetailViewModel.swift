//
//  DetailViewModel.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/4/22.
//

import SwiftUI
import Combine

class DetailViewModel: ObservableObject{
    
    @Published var coinDescription: String? = nil
    @Published var websiteURL:      String? = nil
    @Published var reditURL:        String? = nil
    
    @Published var overViewStatistics:   [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    @Published var coin: Coin
    
    
    private let coinDetailAPIRepository: CoinDetailAPIRepository
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin: Coin){
        self.coin              = coin
        self.coinDetailAPIRepository = CoinDetailAPIRepository(coinID: coin.id)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailAPIRepository.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatisticArrays)
            .sink { [weak self] returnedAraays in
                self?.overViewStatistics   = returnedAraays.overview
                self?.additionalStatistics = returnedAraays.additional
            }
            .store(in: &cancellables)
        
        
        ///Refactor and grab data in mapping
        coinDetailAPIRepository.$coinDetails
            .sink { [weak self] returnedDetails in
                self?.coinDescription = returnedDetails?.readableDescription
                self?.websiteURL      = returnedDetails?.links?.homepage?.first
                self?.reditURL        = returnedDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
        
        
    }
    private func mapDataToStatisticArrays(details returnedDetails: CoinDetailData?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]){
        
        let overviewArray  = createOverViewArray(coin: coin)
        let addtionalArray = createAdditionalArray(details: returnedDetails)
        
        return (overviewArray, addtionalArray)
    }
    private func createOverViewArray(coin: Coin) -> [Statistic] {
        ///Overview Array
        let price                  = coin.currentPrice.asCurrencyWith6Decimals()
        let percentChange          = coin.priceChangePercentage24H
        let priceStat              = Statistic(title: "Current Price", value: price, percentage: percentChange)
        
        let marketCap              = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketPercentCapChange = coin.marketCapChangePercentage24H
        let marketCapStat          = Statistic(title: "Market Capitalization", value: marketCap, percentage: marketPercentCapChange)
        
        let rank                   = "\(coin.rank)"
        let rankStat               = Statistic(title: "Rank", value: rank)
        
        let volume                 = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat             = Statistic(title: "Volume", value: volume)
        
        let overviewArray          = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        
        return overviewArray
    }
    private func createAdditionalArray(details returnedDetails: CoinDetailData?) -> [Statistic]{
        ///Additional Array
        let high                   = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat               = Statistic(title: "24H High", value: high)
        
        let low                    = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat                = Statistic(title: "24H Low", value: low)
        
        let priceChange            = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let percentChange          = coin.priceChangePercentage24H
        let priceChangeStat        = Statistic(title: "24H Price Change", value: priceChange, percentage: percentChange)
        
        let marketCapChange        = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketPercentCapChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat    = Statistic(title: "24H Market Cap Change",
                                            value: marketCapChange,
                                            percentage: marketPercentCapChange)
        
        let blockTime              = returnedDetails?.blockTimeInMinutes ?? 0
        let blockTimeString        = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat              = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashing                = returnedDetails?.hashingAlgorithm ?? ""
        let hashingStat            = Statistic(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray        = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return additionalArray
    }
}

