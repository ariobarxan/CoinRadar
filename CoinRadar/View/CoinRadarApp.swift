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
    @State private var showLunchView   = true
    @StateObject private var viewModel = HomeViewModel()
    
    //MARK: - Initializer
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes      = [.foregroundColor: UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor              = UIColor.clear
        UINavigationBar.appearance().tintColor                = UIColor(Color.theme.accent)
    }

    //MARK: - Main Window
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView{
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(viewModel)
                
                ZStack{
                    if showLunchView{
                        LunchView(showLunchView: $showLunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
