//
//  SecurityImageView.swift
//  InvestTrack
//
//  Created by Соня on 09.03.2024.
//

//import SwiftUI
//
//struct SecurityImageView: View {
//    
//    @StateObject var vm: SecurityImageViewModel
//    
//    init(security: SecurityModel) {
//        _vm = StateObject(wrappedValue: SecurityImageViewModel(security: security))
//    }
//    
//    var body: some View {
//        
//        ZStack {
//            if let image = vm.image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//            } else if vm.isLoading {
//                ProgressView()
//            } else {
//                Image(systemName: "questionmark")
//                    .foregroundColor(Color.theme.secondaryText)
//            }
//        }
//    }
//}
//
//struct SecurityImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecurityImageView(security: dev.security)
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}
