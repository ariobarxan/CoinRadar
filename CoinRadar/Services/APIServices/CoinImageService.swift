//
//  CoinImageService.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import Foundation
import Combine
import UIKit

class CoinImageService{
    
    @Published var image: UIImage? = nil
     
    var subscription: AnyCancellable?
    
    init(url: String){
        getCoinImage(from: url)
    }
    
    func getCoinImage(from url: String){
        guard let url = URL(string: url)
        else {
            print("URL for COIN Image is Not Valid")
            return
        }
        
        
        subscription = NetwoManager.shared.getData(from: url)
            .tryMap{ data -> UIImage? in
                return UIImage(data: data)
            }
            .sink(receiveCompletion: NetwoManager.shared.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self else {return}
                self.image = returnedImage
                self.subscription?.cancel()
            })
    }
}
