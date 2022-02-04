//
//  PortfolioView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/3/22.
//

import SwiftUI

struct PortfolioView: View {
    
    //MARK: - Var
    @EnvironmentObject private var viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    //TODO: - Refactor this abomination! Move the logic to VM
    @State private var selectedCoin: Coin? = nil
    @State private var quantity: String    = ""
    @State private var animation           = false
    @State private var showCheckMark       = false
    
    //MARK: - MainBody
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    
                    SearchBarView(searchString: $viewModel.searchString)
                    
                    coinScroll
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CloseButton()
                        .onTapGesture {
                            self.dismiss()
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            }
            .onChange(of: viewModel.searchString) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}

extension PortfolioView{
    //MARK: - Views
    private var coinScroll:            some View {
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(viewModel.searchString.isEmpty ?
                        viewModel.profolioCoin :
                        viewModel.coins
                ){ coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ?
                                    Color.theme.green :
                                    Color.clear,
                                    lineWidth: 1)
                        )
                        .onTapGesture {
                            withAnimation(.easeIn){
                                self.updateSelectedCoin(coin: coin)
                            }
                        }
                  
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    private var portfolioInputSection: some View {
        VStack(spacing: 20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
        
                Spacer()

                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()

            HStack{
                Text("Amount holding:")
                
                
                Spacer()

                TextField("Ex. 1.4", text: $quantity)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }

            Divider()

            HStack{
                Text("Current Value:")

                Spacer()

                Text(currentValue().asCurrencyWith2Decimals())
            }
        }
        .padding()
        .font(.headline)
        .animation(nil, value: UUID())
    }
    private var trailingNavBarButton:  some View {
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button(action: {
                saveButtonPressed()
            }){
                Text("SAVE")
            }
            .opacity(
                (selectedCoin != nil &&
                 selectedCoin?.currentHoldings != Double(quantity)) ?
                1.0 : 0.0
            )
            .disabled(
                (selectedCoin == nil ||
                selectedCoin?.currentHoldings == Double(quantity)) ?
                true : false )
        }
        .font(.headline)
    }
    
    //TODO: - Refactor
    private func currentValue() -> Double {
        if let quantity = Double(quantity){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    private func saveButtonPressed() {
        guard let coin   = selectedCoin,
              let amount = Double(quantity)
        else {return}
        
        ///Save to portfolio
        viewModel.updatePortfolio(coin: coin, amount: amount)
        
        ///Show Checkmark and Remove the selected coin
        withAnimation {
            self.showCheckMark = true
            removeSelectedCoin()
        }
        
        ///Hide the keyboard
        UIApplication.shared.endEditting()
        
        ///Hide Checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut){
                showCheckMark = false
            }
        }
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        viewModel.searchString = ""
    }
    
    private func updateSelectedCoin(coin: Coin){
        selectedCoin = coin
        
        if let portfolioCoin = viewModel.profolioCoin.first(where: {$0.id == coin.id}),
           let amount = portfolioCoin.currentHoldings{
                quantity = "\(amount)"
        }else{
            quantity = ""
        }
    }
}

