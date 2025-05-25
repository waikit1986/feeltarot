//
//  ContentView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        VStack {
            if userManager.id != nil {
                JournalView()
            } else {
                LoginView()
            }
        }
        .padding()
        .fontDesign(.rounded)
    }
}

#Preview {
    HomeView()
        .environmentObject(UserManager())
}


