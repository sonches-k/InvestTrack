//
//  HomeView.swift
//  InvestTrack
//
//  Created by Соня on 15.02.2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var selectedSecurity: SecurityModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(
                    isPresented: $showPortfolioView,
                    onDismiss: {
                        vm.loadPortfolio()
                    },
                    content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            VStack {
                homeHeader
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPortfolio {
                    allSecuritiesList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioSecuritiesList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView()
            })
        }
        .background(  
            NavigationLink(destination: DetailLoadingView(security: $selectedSecurity), 
                           isActive: $showDetailView,
                           label: { EmptyView() })
        )
    }
}


extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(nil, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
            
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Current Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(nil, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "arrow.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    vm.loadPortfolio()
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var allSecuritiesList: some View {
            List {
                ForEach(vm.allSecurities) { security in
                    SecurityRowView(security: security, showHoldingsColumn: false)
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                        .onTapGesture {
                            segue(security: security)
                        }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                vm.refreshSecurities()
                HapticManager.shared.triggerImpactFeedback()
            }
        }
    
    private var portfolioSecuritiesList: some View {
        List {
            ForEach(vm.portfolioSecurities) {
                security in SecurityRowView(security: security, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(security: security)
                    }
            }
        }
        
        .listStyle(PlainListStyle())
    }
    
    private func segue(security: SecurityModel) {
        selectedSecurity = security
        showDetailView.toggle()
        
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Security")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .initial || vm.sortOption == .initialReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .initial ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .initial ? .initialReversed : .initial
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .priceReversed ? .price : .priceReversed
                    }
                }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
