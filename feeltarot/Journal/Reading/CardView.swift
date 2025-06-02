//
//  CardListView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/31/25.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var journalVM: JournalVM
    
    var body: some View {
        if journalVM.randomCard == nil {
            Text("Meditate & Tap me\n for 3 seconds")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .shadow(color: colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8), radius: 10)
            
            Image("card-back")
                .resizable()
                .aspectRatio(2.5/3.5, contentMode: .fit)
                .frame(width: 150)
                .cornerRadius(9)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white.opacity(1), lineWidth: 1)
                )
                .shadow(
                    color: colorScheme == .dark ? .white.opacity(1) : .black.opacity(1),
                    radius: 25,
                    x: 0,
                    y: 5
                )
                .onLongPressGesture(minimumDuration: 3) {
                    withAnimation(.easeInOut(duration: 1)) {
                        journalVM.randomNumberCard()
                        journalVM.isShowingTextField = false
                        Task {
                            journalVM.startProgressView()
                            journalVM.startStatusRotation()
                            await journalVM.sendAIRequest()
                        }
                    }
                }
        } else {
            if let randomCard = journalVM.randomCard {
                if journalVM.isLoading {
                    VStack {
                        Text(journalVM.statusText)
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        ProgressView(value: journalVM.progress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(width: 200)
                    }
                    .padding()
                    .onAppear {
                        journalVM.startProgressView()
                        journalVM.startStatusRotation()
                    }
                    .onDisappear {
                        journalVM.progressTimer?.invalidate()
                        journalVM.statusTimer?.invalidate()
                    }
                }
                
                Image(String(randomCard))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .cornerRadius(9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white.opacity(1), lineWidth: 1)
                    )
                    .shadow(
                        color: colorScheme == .dark ? .white.opacity(1) : .black.opacity(1),
                        radius: 25,
                        x: 0,
                        y: 5
                    )
                
                ReadingView()
            }
        }
    }
}

#Preview {
    CardView()
        .environmentObject(JournalVM())
}

