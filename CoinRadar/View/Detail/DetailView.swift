//
//  DetailView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/4/22.
//

import SwiftUI


struct DetailLoadingView: View{
    //MARK: - Var
    @Binding var  coin: Coin?
    
    init(coin: Binding<Coin?>){
        self._coin = coin
    }
    
    //MARK: - Body
    var body: some View {
        ZStack{
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    //MARK: - Var
    @StateObject private var viewModel: DetailViewModel
    
    @State private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let gridSpacing:    CGFloat    = 30
    
    //MARK: - Initializer
    init(coin: Coin){
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    //MARK: - Body
    var body: some View {
        ScrollView{
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20){
                   
                        
                    
                    overViewSection

                    addtionalDetailSection
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationTrailingItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView{
    //MARK: - Views
    private var overViewSection:        some View {
        VStack(spacing: 20){
            ///Title
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            ///Body
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: gridSpacing,
                      pinnedViews: []) {
                
                ForEach(viewModel.overViewStatistics){ statistic in
                    StatisticView(stat: statistic)
                }
            }
        }
    }
    private var addtionalDetailSection: some View {
        VStack(spacing: 20){
            ///Title
            Text("Additional Details")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            ///Body
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: gridSpacing,
                      pinnedViews: []) {
                
                ForEach(viewModel.additionalStatistics){ statistic in
                    StatisticView(stat: statistic)
                }
            }
        }
    }
    private var navigationTrailingItem: some View {
        HStack{
            
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            
            CoinImageView(url: viewModel.coin.image,
                          coinID: viewModel.coin.id)
                .frame(size: 25)
            
        }
    }
}
