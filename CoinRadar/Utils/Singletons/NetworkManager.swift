//
//  NetworkManager.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import Foundation
import Combine

class NetwoManager{
    
    static let shared = NetwoManager()
        
    func fetchData(from url: URL) -> AnyPublisher<Data, Error>{
            URLSession.shared
                .dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .tryMap{try self.handleURLResponse(output: $0, url: url)}
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
                
    }
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            throw NetworkingError.badURLResponse(url: url)
            }
        return output.data
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
            case .finished:
                break
            case .failure(let error):
                print("Sinking Error \(error.localizedDescription)")
                break
        }
    }
}
