//
//  HomeView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/1/22.
//

import SwiftUI

struct HomeView: View {
    
    //MARK: - Var
    @State private var showPortdolio = false
    
    
    //MARK: - MainBody
    var body: some View {
        ZStack{
            //Background Layer
            Color.theme.background.ignoresSafeArea()
            
            
            
            //Content Layer
            VStack{
               
                header
                    .padding(.horizontal)
                
                Spacer()
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
    }
}

extension HomeView{
    private var header: some View {
        HStack{
            
            //Left Button
            CircleButton(iconName: showPortdolio ? "plus" : "info")
                .animation(nil, value: showPortdolio)
                .background(
                    CircleButtonAnimation(animate: $showPortdolio)
                )
                
           Spacer()
            
            //Header Title
            Text(showPortdolio ? "Portfolio" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(nil, value: showPortdolio)

            Spacer()
            
            //Right Button
            CircleButton(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortdolio ?
                                      180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortdolio.toggle()
                }
            }
        }
    }
}
