//
//  BackgroundView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/3/25.
//

import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var journalVM: JournalVM
    
    var body: some View {
        Image("background-\(String(journalVM.randomBackground))")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            .offset(x: (journalVM.randomBackground == 1) ? -50 : 0)
            .ignoresSafeArea()
            .opacity(journalVM.isShowingCardView ? 0.5 : 1)
            .animation(.easeInOut(duration: 1), value: journalVM.isShowingCardView)
    }
}

#Preview {
    BackgroundView()
        .environmentObject(JournalVM())
}
