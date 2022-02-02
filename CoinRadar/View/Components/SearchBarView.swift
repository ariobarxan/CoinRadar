//
//  SearchBarView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/2/22.
//

import SwiftUI

struct SearchBarView: View {
    
    //MARK: - Var
    @Binding var searchString: String
    
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchString.isEmpty ?
                    Color.theme.secondaryText:
                    Color.theme.accent
                )
            
            TextField("Search by name or symbol ...", text: $searchString)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme.accent)
                        .padding()
                        .offset(x: 10)
                        .opacity(searchString.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditting()
                            self.searchString = ""
                        }
                }
        }
        
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.15),
                        radius: 10,
                        x: 0, y: 0)
                
        )
        .padding()
        
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SearchBarView(searchString: .constant(""))
                .previewLayout(.sizeThatFits)
            
            SearchBarView(searchString: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
