//
//  CoinImageViewModel.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import Foundation
import Combine
import SwiftUI

class CoinImageViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    var url: String
    var coinID: String
    
    private let APIService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(url: String, coinID: String){
        self.url        = url
        self.coinID     = coinID
        self.APIService = CoinImageService(url: url, coinID: coinID)
        self.addSubscribers()
        self.isLoading  = true
    }
    
    private func addSubscribers(){
        APIService.$image
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.isLoading = false
            } receiveValue: {[weak self] returnedImage in
                guard let self = self else {return}
                self.image = returnedImage
            }
            .store(in: &cancellables)
    }
    
    
}
