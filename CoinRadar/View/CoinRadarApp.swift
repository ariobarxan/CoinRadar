//
//  CoinRadarApp.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/1/22.
//

import SwiftUI

@main
struct CoinRadarApp: App {
    
    //MARK: - Vars
    @StateObject private var viewModel = HomeViewModel()
    
    //MARK: - Main Window
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(viewModel)
        }
    }
}
