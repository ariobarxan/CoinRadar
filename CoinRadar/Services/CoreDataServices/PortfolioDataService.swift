//
//  PortfolioDataService.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/4/22.
//

import Foundation
import CoreData
import Combine

class PortfolioDataService: ObservableObject{
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    private let container:     NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName:    String = "PortfolioEntity"
    
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let err = error{
                print("Error loading CoreData \(err)")
            }
            self.fetchPortfolio()
        }
    }
    
    func updatePortfolio(coinID: String, amount amountHolding: Double){
        
        ///Update and Delete
        if let entity = savedEntities.first(where: {$0.coinID == coinID}){
            amountHolding > 0 ? update(entity: entity, amount: amountHolding) : delete(entity: entity)
        }else {
            ///ADD
            addToPortfolio(coinID: coinID, amount: amountHolding)
        }
    }
    
    private func fetchPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
           savedEntities = try container.viewContext.fetch(request)
        }catch let error{
            print("Error fetching portfolio: \(error)")
        }
        
    }
    private func addToPortfolio(coinID: String, amount amountHolding: Double){
        let entity           = PortfolioEntity(context: container.viewContext)
        entity.coinID        = coinID
        entity.amountHolding = amountHolding
        
        applyChanges()
    }
    private func save(){
        do {
            try container.viewContext.save()
            
        }catch let error {
            print("Error saving entity: \(error)")
        }
    }
    private func applyChanges(){
        save()
        fetchPortfolio()
    }
    private func update(entity: PortfolioEntity, amount amountHolding: Double){
        entity.amountHolding = amountHolding
        applyChanges()
    }
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
}
