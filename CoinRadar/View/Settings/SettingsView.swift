//
//  SettingsView.swift
//  CoinRadar
//
//  Created by Amirreza Zarepour on 2/6/22.
//

import SwiftUI

struct SettingsView: View {
    
  //MARK: - Var
    @Environment(\.dismiss) var dismiss
    private let viewModel = SettingsViewModel()
   
    
    //MARK: - Body
    var body: some View {
        NavigationView{
            List{
                personalSection
                
                endorsementSection

                APITSection
                    
                applicationSection
            }
            .tint(.blue)
            .font(.headline)
            .listStyle(GroupedListStyle())
            .navigationTitle("Setting")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CloseButton()
                        .onTapGesture {
                            self.dismiss()
                        }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView{
    private var endorsementSection:  some View {
        Section {
            
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(size: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app implementation is originally inspired by a Youtube tutorial at @SwiftfulThinking.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Youtube course Link", destination: viewModel.defualtURL)
        } header: {
            Text("Endorsment")
        }
    }
    private var APITSection:         some View {
        Section {
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The data which is powered this app come from Coin Gecko Website.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Link to website", destination: viewModel.coinGeckoURL)
        } header: {
            Text("API Endorsment")
        }
    }
    private var personalSection:     some View {
        Section {
            VStack(alignment: .leading){
                Image("developer")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(Circle())
                
                Text("Amirreza Zarepour I'm iosDeveloper, who loves building beautiful UIs and great UXs. You can rarely catch me talking about things that aren’t programming, gaming, travel, and politic.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Linkedin Account", destination: viewModel.personalURL)
        } header: {
            Text("Developer")
        }
    }
    private var applicationSection:  some View {
        Section {
            Link("Terms of Service", destination: viewModel.personalURL)
            Link("Privacy Policy", destination: viewModel.personalURL)
            Link("Company Website", destination: viewModel.personalURL)
            Link("Learn more", destination: viewModel.personalURL)
        } header: {
            Text("Application")
        }
    }
    
}
