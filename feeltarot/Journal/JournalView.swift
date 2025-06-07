//
//  JournalView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var journalVM: JournalVM
    @EnvironmentObject var loginVM: LoginVM
    @EnvironmentObject var keyboard: KeyboardObserver
    
    var body: some View {
        NavigationStack {
            VStack {
                if journalVM.isShowingTextField {
                    Spacer()
                    
                    Spacer()
                    
                    TextField("What's in your mind now?", text: $journalVM.situation)
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
                
                if journalVM.isShowingTextField {
                    MenuView()
                }
            }
            .background {
                BackgroundView()
            }
            .onTapGesture {
                keyboard.hideKeyboard()
            }
        }
    }
}

#Preview {
    JournalView()
        .environmentObject(HomeVM())
        .environmentObject(JournalVM())
        .environmentObject(LoginVM())
        .environmentObject(KeyboardObserver())
}
