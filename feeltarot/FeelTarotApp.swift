//
//  feeltarotApp.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import SwiftUI

@main
struct FeelTarotApp: App {
    
    @StateObject var userManager = UserManager()
    @StateObject var homeVM = HomeVM()
    @StateObject var loginVM = LoginVM()
    @StateObject var keyboard = KeyboardObserver()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(userManager)
                .environmentObject(homeVM)
                .environmentObject(loginVM)
                .environmentObject(keyboard)
        }
    }
}
