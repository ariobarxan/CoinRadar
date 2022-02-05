//
//  LunchView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/6/22.
//

import SwiftUI

struct LunchView: View {
    //MARK: - Var
    @Binding var showLunchView: Bool
    
    @State private var loadingText: [String]   = "Updating prices...".map{String($0)}
    @State private var showLoadingText: Bool = false
    @State private var counter: Int          = -1
    @State private var loops:   Int          = 0
   
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    //MARK: - Body
    var body: some View {
        ZStack{
            Color.lunch.background.ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(size: 100)
            
            ZStack{
                if showLoadingText{
                    
                    HStack(spacing: 0){
                        ForEach(loadingText.indices){ index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundColor(Color.lunch.accent)
                                .fontWeight(.heavy)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            self.showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()){
                if counter == loadingText.count - 1 {
                    counter = 0
                    loops  += 1
                    if loops >= 2 {
                        showLunchView = false
                    }
                }else {
                    counter += 1
                }
            }
        }
    }
}

struct LunchView_Previews: PreviewProvider {
    static var previews: some View {
        LunchView(showLunchView: .constant(true))
    }
}
