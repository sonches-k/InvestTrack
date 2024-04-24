//
//  InvestTrackApp.swift
//  InvestTrack
//
//  Created by Соня on 15.02.2024.
//

//import SwiftUI
//
//@main
//struct InvestTrackApp: App {
//    
//    @StateObject private var vm = HomeViewModel()
//    
//    var body: some Scene {
//        WindowGroup {
//            let isRegistered = KeychainManager.shared.isUserRegistered()
//            
//            if isRegistered {
//                HomeView()
//                    .navigationBarHidden(true)
//                    .environmentObject(vm)
//            } else {
//                RegistrationView()
//                    .navigationBarHidden(true)
//            }
//        }
//    }
//}


import SwiftUI


@main
struct InvestTrackApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RegistrationView()
                    .navigationBarHidden(true)
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
