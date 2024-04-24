//
//  DetailView.swift
//  InvestTrack
//
//  Created by Соня on 17.04.2024.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var security: SecurityModel?
    var body: some View {
        ZStack {
            if let security = security {
                DetailView(security: security)
            }
        }
    }
}

struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 150)),
    ]
    let security: SecurityModel
    
    init(security: SecurityModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(security: security))
        self.security = security
        print("init \(security.name)")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("")
                    .onAppear {
                        vm.fetchDetails(securityId: security.securityId, boardId: security.boardId, analytics: true)
                    }
                let chartHeight: CGFloat = 600
                SimpleLineChartView(data: vm.securityDetails?.data.security.history ?? [])
                    .padding(.horizontal)
                Text("Overview")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          content: {
                    ForEach(vm.overviewStatistics)  { stat in
                        StatisticView(stat: stat)
                    }
                    
                })
                Text("Additional Info")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                LazyVGrid(columns: columns,
                          alignment: .leading,
                          content: {
                    ForEach(vm.additionalStatistics)  { stat in
                        StatisticView(stat: stat)
                    }
                    
                })
            }
            .padding()
        }
        .navigationTitle(security.name)
    }
    
    
    func convertToCandlestickData(history: [SecurityHistory]) -> [CandlestickData] {
        print("History Count: \(history.count)")
        
        // Предполагаем, что массив отсортирован по дате, взять последние 7 элементов
        let lastSevenDays = history.suffix(10)
        
        let convertedData = lastSevenDays.map { item in
            CandlestickData(
                openPrice: item.openPrice,
                closePrice: item.closePrice,
                highPrice: item.highPrice,
                lowPrice: item.lowPrice
            )
        }
        
        print("Converted Data: \(convertedData)") // Отладочный вывод
        return convertedData
    }
    
}
//#Preview {
//    DetailView(security: dev.homeVM)
//}
