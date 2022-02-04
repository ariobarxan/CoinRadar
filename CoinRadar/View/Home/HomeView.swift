//
//  HomeView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/1/22.
//

import SwiftUI

struct HomeView: View {
    
    //MARK: - Var
    @State private var showPortfolio        = false
    @State private var showPortfolioView    = false
    @State private var selectedCoin: Coin?  = nil
    @State private var showDetailView: Bool = false
    @EnvironmentObject private var viewModel: HomeViewModel
    
    //MARK: - MainBody
    var body: some View {
        ZStack{
            ///Background Layer
            backgroundView
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(viewModel)
                }
            
            ///Content Layer
            VStack{
                ///View Header
                header
                    .padding(.horizontal)
                
                HomeStatView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchString: $viewModel.searchString)
                
                ///Coin Row Titles
                columnTitles
                
                ///List of all Coins
                if !showPortfolio {
                    coinsList
                        .transition(.move(edge: .leading))
                }
                
                ///List of Portfolio Coins
                if showPortfolio {
                    portfolioList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
        .background(
            NavigationLink(isActive: $showDetailView,
                           destination: {DetailLoadingView(coin: $selectedCoin)},
                           label: {EmptyView()})
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeViewModel)
    }
}

extension HomeView{
    //MARK: - Views
    private var backgroundView: some View {
        Color.theme.background.ignoresSafeArea()
    }
    private var header:         some View {
        HStack{
            
            //Left Button
            CircleButton(iconName: showPortfolio ? "plus" : "info")
                .animation(nil, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio{
                        self.showPortfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimation(animate: $showPortfolio)
                )
                
           Spacer()
            
            //Header Title
            Text(showPortfolio ? "Portfolio" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(nil, value: showPortfolio)

            Spacer()
            
            //Right Button
            CircleButton(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ?
                                      180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                }
            }
        }
    }
    private var columnTitles:   some View {
        HStack{
            //Left title
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOption == .rank ||
                        viewModel.sortOption == .rankReversed) ?
                        1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
                .onTapGesture {
                    withAnimation(.default){
                        viewModel.sortOption = viewModel.sortOption == .rank ?
                            .rankReversed : .rank
                    }
                }
            
            Spacer()
            
            //Center title -> only available in Portfolio
            if showPortfolio{
                HStack(spacing: 4){
                    Text("Holdings")
                        
                    Image(systemName: "chevron.down")
                        .opacity(
                            (viewModel.sortOption == .holdings ||
                            viewModel.sortOption == .holdingsReversed) ?
                            1.0 : 0.0
                        )
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default){
                        viewModel.sortOption = viewModel.sortOption == .holdings ?
                            .holdingsReversed : .holdings
                    }
                }

                
            }
            
            //Right title
            HStack(spacing: 4){
                Text("Price")
                    
                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOption == .price ||
                        viewModel.sortOption == .priceReversed) ?
                        1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
                .frame(width: screen.width / 3.5)
                .onTapGesture {
                    withAnimation(.default){
                        viewModel.sortOption = viewModel.sortOption == .price ?
                            .priceReversed : .price
                    }
                }

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    private var coinsList:      some View {
        List{
            ForEach(viewModel.coins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(
                        .init(top: 10, leading: 0, bottom: 10, trailing: 10)
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            //animation
            viewModel.reloadData()
        }
    }
    private var portfolioList:  some View {
        List{
            ForEach(viewModel.profolioCoin){ coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(
                        .init(top: 10, leading: 0, bottom: 10, trailing: 10)
                    )
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: Coin){
        selectedCoin = coin
        showDetailView.toggle()
    }
}
