//
//  CoinImageView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import SwiftUI

struct CoinImageView: View {
    
    //MARK: - Var
    
    @StateObject private var viewModel: CoinImageViewModel
    
    
    init(url: String){
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(url: url))
    }
    
    var body: some View {
        ZStack{
            if let image = viewModel.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            }else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
            
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(url: dev.coin.image)
            .previewLayout(.sizeThatFits)
    }
}


