//
//  CoinAPIService.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import Foundation
import Combine

class CoinAPIService: ObservableObject{
    @Published var coins: [Coin] = []
    
    var subscription: AnyCancellable?
    
    init(){
        
        fetchCoins()
    }
    
    
    private func fetchCoins(){
        guard let url = URL(string: SharedResources.instance.coinAPIURL)
        else {
            print("URL for COINS is Not Valid")
            return
        }
        
        
        subscription = URLSession.shared
                        .dataTaskPublisher(for: url)
                        .subscribe(on: DispatchQueue.global(qos: .background))
                        .tryMap { output -> Data in
                            guard let response = output.response as? HTTPURLResponse,
                                  response.statusCode >= 200 && response.statusCode < 300
                            else {
                                throw URLError(.badServerResponse)
                            }
                
                            return output.data
                        }
                        .receive(on: DispatchQueue.main)
                        .decode(type: [Coin].self, decoder: JSONDecoder())
                        .sink(receiveCompletion: { completion in
                            switch completion{
                            case .finished:
                                break
                            case .failure(let error):
                                print("Sinking Error \(error.localizedDescription)")
                                break
                            }
                        }) { [weak self] returnedCoins in
                            guard let self = self else {return}
                            self.coins     = returnedCoins
                            self.subscription?.cancel()
                        }
            
        
    }
    
    
}
