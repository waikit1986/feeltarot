//
//  JournalView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var journalVM: JournalVM
    @EnvironmentObject var loginVM: LoginVM
    @EnvironmentObject var keyboard: KeyboardObserver
    
    var body: some View {
        VStack {
            if journalVM.isShowingTextField {
                Spacer()
                
                Spacer()
                
                TextField("How are you feeling now?", text: $journalVM.situation)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8), radius: 10)
                
                if journalVM.situation != "" {
                    JournalButtonView()
                }
                
                Spacer()
            }
            
            if journalVM.isShowingCardView {
                CardView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: journalVM.isShowingCardView)
                
            }
            
            if journalVM.isShowingTextField {
                Spacer()
            }
        }
        .background {
            BackgroundView()
        }
        .onTapGesture {
            keyboard.hideKeyboard()
        }
        .task {
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
    JournalView()
        .environmentObject(JournalVM())
        .environmentObject(LoginVM())
        .environmentObject(KeyboardObserver())
}
