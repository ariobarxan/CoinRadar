//
//  LocalFileManager.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import Foundation
import UIKit.UIImage

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init(){}
    
    func saveImage(_ image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(name: folderName)
        
        //Get path for Image and extract image data
        guard let data = image.pngData(),
              let url  = setImageURL(name: imageName, inFolder: folderName )
        else {return}
        
        //Save Image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("[FileManager Error] Image Name:\(imageName)  error:\(error.localizedDescription)")
        }
       
    }
    
    func fetchImage(name imageName: String, from folderName: String)  -> UIImage? {
        guard
            let url = setImageURL(name: imageName, inFolder: folderName)?.path,
            FileManager.default.fileExists(atPath: url)
        else {
            print("Image doesn't exist ")
            return nil
        }
        
        return UIImage(contentsOfFile: url)
    }
    
    private func setFolderURL(name folderName: String) -> URL?{
        guard let url = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
            print("[File Manager Error] could not get path")
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func setImageURL(name imageName: String, inFolder folderName: String) -> URL?{
        guard let folderURL = setFolderURL(name: folderName) else {return nil}
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
    private func createFolderIfNeeded(name folderName: String){
        guard
            let url = setFolderURL(name: folderName),
            !FileManager.default.fileExists(atPath: url.path)
        else {
            print("Folder already exist")
            return
            
        }
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            print("Folder is successfully created")
        }catch let error{
            print("[FileManager Error]: Error creating directory: \(folderName) error: \(error.localizedDescription)")
        }
        
    }
}
