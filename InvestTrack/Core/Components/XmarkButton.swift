//
//  XmarkButton.swift
//  InvestTrack
//
//  Created by Соня on 29.03.2024.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark")
        }
    }
}


#Preview {
    XmarkButton()
}
