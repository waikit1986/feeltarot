//
//  JournalButtonView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/3/25.
//

import SwiftUI

struct JournalButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var journalVM: JournalVM
    @EnvironmentObject var keyboard: KeyboardObserver
    
    var body: some View {
        Button {
            Task {
                keyboard.hideKeyboard()
                withAnimation(.spring(dampingFraction: 0.6)) {
                    journalVM.tappedJournalButton()
                }
            }
        } label: {
            if journalVM.isLoading {
                ProgressView()
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity)
                
            } else {
                Text("I'm Ready")
                    .frame(maxWidth: .infinity)
            }
        }
        .disabled(journalVM.situation.isEmpty || journalVM.isLoading)
        .padding()
        .background(Color("AccentColor"))
        .foregroundColor(.black)
        .cornerRadius(12)
        .shadow(color: colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8), radius: 10)
        .padding(.horizontal)
    }
}

#Preview {
    JournalButtonView()
        .environmentObject(JournalVM())
        .environmentObject(KeyboardObserver())
}
