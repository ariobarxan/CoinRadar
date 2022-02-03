//
//  HomeViewModel.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject{
    @Published var coins: [Coin]         = []
    @Published var profolioCoin: [Coin]  = []
    @Published var searchString: String  = ""
    private let APIService               = CoinAPIService()
    private var cancellables             = Set<AnyCancellable>()
    
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
            .combineLatest(APIService.$coins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filteredCoins)
            .sink { [weak self] filteredCoins in
                self?.coins = filteredCoins
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
}
