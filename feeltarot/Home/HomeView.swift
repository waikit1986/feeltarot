//
//  ContentView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var journalVM: JournalVM
    @EnvironmentObject var loginVM: LoginVM
    
    var body: some View {
        VStack {
            switch homeVM.selection {
            case 0:
                JournalView()
            case 1:
                ReadingListView()
            case 2:
                SettingsView()
            case 3:
                WelcomeView()
            default:
                JournalView()
            }
        }
        .fontDesign(.rounded)
        .task {
            homeVM.checkKeychainIsEmpty()
            homeVM.checkTokenIsEmpty()
            journalVM.randomNumberBackground()
            loginVM.startRepeatingTimer()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    print("active back")
                    await loginVM.reLogin()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeVM())
        .environmentObject(LoginVM())
        .environmentObject(JournalVM())
}
