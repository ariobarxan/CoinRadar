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
    
    private let APIService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(url: String){
        self.url        = url
        self.APIService = CoinImageService(url: url)
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
