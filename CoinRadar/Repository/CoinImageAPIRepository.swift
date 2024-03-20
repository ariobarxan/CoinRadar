//
//  CoinImageAPIRepository.swift
//  CoinRadar
//
//  Created by Home on 20/3/2024.
//

import UIKit
import Combine

protocol CoinImageAPIRepositoryProtocol: ObservableObject {
    var image: UIImage? {get set}
    func getImage(forCoinURL url: String)
}

final class CoinImageAPIRepository: CoinImageAPIRepositoryProtocol {
    @Published var image: UIImage? = nil
    private var subscription: AnyCancellable?
    private let coinImageAPIService: CoinImageService?
    
    
    init(coinID: String, coinURl: String) {
        coinImageAPIService = CoinImageService(url: coinURl, coinID: coinID)
        addSubcriber()
    }
    
    private func addSubcriber() {
        subscription = coinImageAPIService?.$image
            .sink { [weak self] returnedImage in
                self?.image = returnedImage
            }
    }
    
    func getImage(forCoinURL url: String) {
        // TODO: - This should call the api to download image
    }
}
