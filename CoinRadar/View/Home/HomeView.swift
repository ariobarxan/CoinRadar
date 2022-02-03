//
//  HomeView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/1/22.
//

import SwiftUI

struct HomeView: View {
    
    //MARK: - Var
    @State private var showPortfolio = false
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    //MARK: - MainBody
    var body: some View {
        ZStack{
            //Background Layer
            backgroundView
            
            //Content Layer
            VStack{
                //View Header
                header
                    .padding(.horizontal)
                
                HomeStatView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchString: $viewModel.searchString)
                
                //Coin Row Titles
                columnTitles
                
                //List of all Coins
                if !showPortfolio {
                    coinsList
                        .transition(.move(edge: .leading))
                }
                
                //List of Portfolio Coins
                if showPortfolio {
                    portfolioList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
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
            Text("Coin")
            
            Spacer()
            
            //Center title -> only available in Portfolio
            if showPortfolio{
                Text("Holdings")
            }
            
            //Right title
            Text("Price")
                .frame(width: screen.width / 3.5)
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
            }
        }
        .listStyle(PlainListStyle())
    }
    private var portfolioList:  some View {
        List{
            ForEach(viewModel.coins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(
                        .init(top: 10, leading: 0, bottom: 10, trailing: 10)
                    )
            }
        }
        .listStyle(PlainListStyle())
    }
}
