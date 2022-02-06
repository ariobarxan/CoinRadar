//
//  MarketAPIService.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/3/22.
//

import Foundation
import Combine

class MarketAPIService: ObservableObject{
    @Published var marketData: MarketData? = nil
    
    var subscription: AnyCancellable?
    
    init(){
        downloadMarketData()
    }
        
    func downloadMarketData(){
        guard let url = URL(string: SharedResources.instance.marketAPIURL)
        else {
            print("URL for Market is Not Valid")
            return
        }
        
        
        subscription =  NetwoManager.shared.getData(from: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetwoManager.shared.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                guard let self = self else {return}
                self.marketData     = returnedGlobalData.data
                self.subscription?.cancel()
            })
    }
}
