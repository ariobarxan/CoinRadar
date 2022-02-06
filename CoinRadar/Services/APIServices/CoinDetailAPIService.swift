//
//  CoinDetailAPIService.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/4/22.
//

import Foundation
import Combine

class CoinDetailAPIService: ObservableObject{
    @Published var coinDetails: CoinDetailData? = nil
    
    var subscription: AnyCancellable?
    let coinID: String
    
    init(coinID: String){
        
        self.coinID = coinID
        
        downloadCoinDetailData()
    }
    
    
    func downloadCoinDetailData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coinID)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else {
            print("URL for COINS Detail is Not Valid")
            return
        }
        
        
        subscription =  NetwoManager.shared.getData(from: url)
            .decode(type: CoinDetailData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetwoManager.shared.handleCompletion, receiveValue: { [weak self] returnedDetails in
                guard let self       = self else {return}
                self.coinDetails     = returnedDetails
                self.subscription?.cancel()
            })
    }
    
    
}
