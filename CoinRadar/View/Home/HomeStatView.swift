//
//  HomeStatView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/3/22.
//

import SwiftUI

struct HomeStatView: View {
    
    //MARK: - Var
    @Binding var showPortfolio: Bool
    @EnvironmentObject private var viewModel: HomeViewModel
    
    //MARK: - MainBody
    var body: some View {
        HStack{
            ForEach(viewModel.statisicst){ stat in
                StatisticView(stat: stat)
                    .frame(width: screen.width / 3)
            }
        }
        .frame(width: screen.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatView(showPortfolio: .constant(false))
            .environmentObject(dev.homeViewModel)
    }
}


