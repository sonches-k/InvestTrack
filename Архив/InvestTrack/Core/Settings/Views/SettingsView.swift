//
//  SettingsView.swift
//  InvestTrack
//
//  Created by Соня on 23.04.2024.
//

import SwiftUI



import SwiftUI

struct SettingsView: View {
    let moexURL = URL(string: "https://www.moex.com/")!
    let personalURL = URL(string: "https://t.me/k_sonchess")!
    let coworkerURL = URL(string: "https://t.me/nasavasa")!
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("InvestTrack")) {
                    VStack(alignment: .leading) {
                        Image("logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Text("This is our course project")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.theme.accent)
                    }
                    .padding(.vertical)
                    Link("Sonya's tg", destination: personalURL)
                    Link("Vasya's tg", destination: coworkerURL)
                    Link("MOEX", destination: moexURL)
                }
                
                Section(header: Text("Settings")) {
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark Mode")
                    }
                    .onChange(of: isDarkMode) { newValue in
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                    }
                }
            }
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton()
                }
            }
        }
    }
}


#Preview {
    SettingsView()
}
