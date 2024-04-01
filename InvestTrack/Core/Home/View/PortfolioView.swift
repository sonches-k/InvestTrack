//
//  PortfolioView.swift
//  InvestTrack
//
//  Created by Соня on 29.03.2024.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var wantedSecurity: SecurityModel? = nil
    @State private var wantedSecurityLot: Int = 0
    @State private var quantityText: String = ""
    @State private var showAlert: Bool = false
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    
                    securitySearchList
                    
                    if let security = wantedSecurity  {
                        VStack(spacing: 20) {
                            HStack {
                                Text("Current price of \(wantedSecurity?.securityId.uppercased() ?? "") (\(wantedSecurity?.boardId.uppercased() ?? "")):")
                                Spacer()
                                Text(wantedSecurity?.currentPrice.asCurrencyWit6hDecimals() ?? "")
                            }
                            .padding()
                            .animation(.none, value: wantedSecurity?.currentPrice.asCurrencyWit6hDecimals())
                            Divider()
                            HStack {
                                Text("1 lot = \(security.lotSize) sec.")
                                    .multilineTextAlignment(.trailing)
                            }
                            .font(.headline)
                            .padding()
                            .animation(.none, value: security.lotSize)
                            Divider()
                            HStack {
                                Text("You have in portfolio:")
                                Spacer()
                                TextField("Quantity multiple of \(security.lotSize)", text: $quantityText)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                            }
                            .padding()
                            Divider()
                            HStack {
                                Text("Current amount:")
                                Spacer()
                                Text(getCurrentAmount().asCurrencyWit2hDecimals())
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Edit portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Image(systemName: "checkmark")
                            .opacity(showCheckMark ? 1 : 0)
                    Button(action: {
                        saveButtonPressed()
                    }, label: {
                        Text("Save".lowercased())
                    })
                    .opacity(
                        (wantedSecurity != nil && wantedSecurity?.currentHoldings != Double(quantityText)) ? 1 : 0
                        )
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Quantity"), message: Text("Please enter a quantity that is a multiple of \(wantedSecurityLot)"), dismissButton: .default(Text("OK")))
        }
    }
}

extension PortfolioView {
    
    private var securitySearchList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10) {
                ForEach(vm.allSecurities) { security in
                    SecuritySearchView(security: security)
                        .frame(width: 70, height: 100)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                wantedSecurity = security
                                wantedSecurityLot = security.lotSize
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(wantedSecurity?.id == security.id ?
                                        Color.theme.secondaryText : Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        })
    }
    
//    private func getCurrentAmount() -> Double {
//        guard let amount = Double(quantityText), wantedSecurityLot > 0 else { return 0 }
//        if quantityText.isEmpty {
//            return 0
//        } else {
//            let isMultiple = Int(amount) % wantedSecurityLot == 0
//            showAlert = !isMultiple
//            return isMultiple ? amount * (wantedSecurity?.currentPrice ?? 0) : 0
//        }
//    }
    private func getCurrentAmount() -> Double {
        guard let amount = Double(quantityText), wantedSecurityLot > 0 else { return 0 }
        
        if quantityText.isEmpty {
            return 0
        } else {
            let isMultiple = Int(amount) % wantedSecurityLot == 0
            return isMultiple ? amount * (wantedSecurity?.currentPrice ?? 0) : 0
        }
    }

    private func saveButtonPressed() {
        guard let security = wantedSecurity else { return }
        
        let isQuantityValid = isMultipleOfLotSize()
        
        if isQuantityValid {
            // save to portfolio
            
            // show checkmark
            withAnimation(.easeIn) {
                showCheckMark = true
                clearWantedSecurities()
                showAlert = false // Скрыть алерт, если он был виден
            }
            // hide keyboard
            UIApplication.shared.endEditing()
            // hide checkmark
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut) {
                    showCheckMark = false
                }
            }
        } else {
            showAlert = true // Показать алерт, если количество не кратно размеру лота
        }
    }


    
//    private func saveButtonPressed() {
//        
//        guard let security = wantedSecurity else { return }
//        
//        let isQuantityValid = isMultipleOfLotSize()
//        
//        if isQuantityValid {
//            // save to portfolio
//            
//            // show checkmark
//            withAnimation(.easeIn) {
//                showCheckMark = true
//                clearWantedSecurities()
//            }
//            // hide keyboard
//            UIApplication.shared.endEditing()
//            // hide checkmark
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                withAnimation(.easeOut) {
//                    showCheckMark = false
//                }
//            }
//        } else {
//            showAlert = true
//        }
//    }
    
    private func clearWantedSecurities() {
        wantedSecurity = nil
        vm.searchText = ""
    }
    
    private func isMultipleOfLotSize() -> Bool {
        guard let amount = Double(quantityText), wantedSecurityLot > 0 else { return false }
        return amount.truncatingRemainder(dividingBy: Double(wantedSecurityLot)) == 0
    }
}

//#Preview {
//    PortfolioView()
//}
