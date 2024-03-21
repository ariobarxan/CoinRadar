//
//  CoinDetailAPIRepository.swift
//  CoinRadar
//
//  Created by Home on 20/3/2024.
//

import Foundation
import Combine

protocol CoinDetailAPIRepositoryProtocol: ObservableObject {
    var coinDetails: CoinDetailData? {get set}
    var coinID: String {get set}
    
    
    func getCoinDetailData()
}

final class CoinDetailAPIRepository: CoinDetailAPIRepositoryProtocol {
    @Published var coinDetails: CoinDetailData? = nil
    var coinID: String
    private var subscription: AnyCancellable?
    private var coinDetailAPIService: CoinDetailAPIService
    
    init(coinID: String) {
        self.coinID = coinID
        coinDetailAPIService = CoinDetailAPIService(coinID: coinID)
    }
    
    private func addSubscriber() {
        subscription = coinDetailAPIService.$coinDetails
            .sink { [weak self] returnedDetails in
                self?.coinDetails = returnedDetails
            }
    }
    
    func getCoinDetailData() {
        // TODO: - This should call the api to download details
    }
    
    
}
