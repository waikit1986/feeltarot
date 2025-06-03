//
//  ReadingView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//

import SwiftUI

struct CardAnswerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var journalVM: JournalVM
    
    var body: some View {
        if journalVM.isLoading == false {
            VStack {
                Text("You are feeling \(journalVM.emotion)")
                    .font(.title)
                    .padding(.bottom)
                Text(journalVM.answer)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("AnswerBackground"))
            }
            .padding()
            
            Button {
                Task {
                    withAnimation(.default,{
                        journalVM.tappedCardAnswerView()
                    })
                }
            } label: {
                Text("I'm Done")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color("AccentColor"))
            .foregroundColor(.black)
            .cornerRadius(12)
            .shadow(color: colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8), radius: 10)
            .padding(.horizontal)
        }
    }
}

#Preview {
    CardAnswerView()
        .environmentObject(JournalVM())
}
