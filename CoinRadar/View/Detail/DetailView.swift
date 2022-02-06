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
    
    @State private var showDes: Bool       = false
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

                    descriptionSection
                    
                    addtionalDetailSection
                    
                    webPagesSection
                }
                .padding()
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
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
    private var descriptionSection:     some View {
        ZStack{
            if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty{
                
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showDes ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                
                    Button(action: {
                        withAnimation(.easeInOut){
                            showDes.toggle()
                        }
                    }) {
                        Text(showDes ? "Less" : "Read more ..")
                            .font(.caption)
                            .bold()
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
    private var webPagesSection:        some View {
        VStack(alignment: .leading, spacing: 20){
            if let websiteURLString = viewModel.websiteURL,
               let url = URL(string: websiteURLString){
                Link("Website", destination: url)
            }
            
            if let redditURLString = viewModel.reditURL,
               let url = URL(string: redditURLString){
                Link("Reddit", destination: url)
            }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
}
