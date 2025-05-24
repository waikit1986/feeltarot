//
//  feeltarotApp.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import SwiftUI

@main
struct FeelTarotApp: App {
    
    @StateObject var loginVM = LoginVM()
    @StateObject var homeVM = HomeVM()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(loginVM)
                .environmentObject(homeVM)
        }
    }
}
