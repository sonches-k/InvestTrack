//
//  ChartView.swift
//  InvestTrack
//
//  Created by Соня on 19.04.2024.
//

import SwiftUI
import Charts





import SwiftUI
import Charts


struct SimpleLineChartView: View {
    var data: [SecurityHistory]
    @State private var visibleFraction: Double = 0.0
    
    var body: some View {
        let lineColor: Color = determineLineColor(data: data)
        
        Chart {
            ForEach(data, id: \.id) { history in
                if let date = convertToDate(from: history.date) {
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Price", history.closePrice)
                    )
                    .foregroundStyle(lineColor)
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom, values: .automatic)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 300)
        .shadow(color: lineColor, radius: 15, x: 0, y: 10)
        .shadow(color: lineColor.opacity(0.7), radius: 15, x: 0, y: 20)
        .shadow(color: Color.purple.opacity(0.5), radius: 15, x: 0, y: 30)
        .shadow(color: Color.mint.opacity(0.25), radius: 15, x: 0, y: 40)
    }

    private func determineLineColor(data: [SecurityHistory]) -> Color {
        guard let firstPrice = data.first?.closePrice,
              let lastPrice = data.last?.closePrice else {
            return Color.theme.secondaryText
        }
        return firstPrice > lastPrice ? Color.theme.red : Color.theme.green
    }

    // Функция для конвертации строки в дату
    public func convertToDate(from dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        return dateFormatter.date(from: dateString)
    }
}


public func convertToDate(from dateString: String) -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
    return dateFormatter.date(from: dateString)
}


struct CandlestickData: Identifiable {
    let id = UUID()
    let openPrice: Double
    let closePrice: Double
    let highPrice: Double
    let lowPrice: Double
}

extension Array where Element == CandlestickData {
    func maxPrice() -> Double {
        self.max { $0.highPrice < $1.highPrice }?.highPrice ?? 0
    }

    func minPrice() -> Double {
        self.min { $0.lowPrice > $1.lowPrice }?.lowPrice ?? 0
    }
}

