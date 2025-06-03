//
//  ContentView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeVM: HomeVM
    
    var body: some View {
        NavigationStack {
            VStack {
                switch homeVM.selection {
                case 0:
                    JournalView()
                case 1:
                    WelcomeView()
                default:
                    JournalView()
                }
            }
            .fontDesign(.rounded)
            .task {
                homeVM.checkKeychainIsEmpty()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeVM())
}
