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
    let  coin: Coin
    
    
    //MARK: - Body
    var body: some View {
        ZStack{
            
            Text(coin.name)
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin:dev.coin)
    }
}
