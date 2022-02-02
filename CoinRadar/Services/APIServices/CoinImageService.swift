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
    var coinID: String
    
    var url: String
    
    private let fileManager = LocalFileManager.instance
    private let folderName  = "coin_images"
    init(url: String, coinID: String){
        self.coinID = coinID
        self.url    = url
        fetchImage()
        
    }
    
    //TODO: - Refactoring should be done here and repository layer should hold some of this code
    func downloadCoinImage(from url: String){
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
                guard let self = self,
                let returnedImage = returnedImage
                else {return}
                self.image = returnedImage
                self.subscription?.cancel()
                self.fileManager.saveImage(returnedImage, imageName: self.coinID, folderName: self.folderName)
            })
    }
    
    private func fetchImage(){
        if let savedImage = fileManager.fetchImage(name: coinID, from: folderName){
            image = savedImage
            print("Image from FileManager")
        }else{
            downloadCoinImage(from: url)
            print("Image is Downlaoded")
        }
    }
}
