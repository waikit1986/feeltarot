//
//  ReadingView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/5/25.
//

import SwiftUI

struct ReadingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var readingVM: ReadingVM
    
    var reading: ReadingResponse
    
    var body: some View {
        ScrollView {
            if let cardNumber = readingVM.cardNumber {
                Image(String(cardNumber))
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
                    .padding(50)
            }
            
            ReadingAnswerView(reading: reading)
        }
        .background {
            BackgroundView()
        }
        .onAppear {
            readingVM.getCardNumber(cardName: reading.card)
        }
    }
}

#Preview {
    //    ReadingView()
    //        .environmentObject(ReadingVM())
}
