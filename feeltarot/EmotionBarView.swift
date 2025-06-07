//
//  EmotionListView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/7/25.
//

import SwiftUI

struct EmotionBarView: View {
    @EnvironmentObject var readingVM: ReadingVM

    var body: some View {
        GeometryReader { geo in
            let total = readingVM.positiveEmotion + readingVM.negativeEmotion
            let width1 = total > 0 ? CGFloat(readingVM.positiveEmotion / total) * geo.size.width : 0
            
            HStack(spacing: 0) {
                Color.accentColor.frame(width: width1)
                Color.indigo.frame(width: geo.size.width - width1)
            }
            .cornerRadius(4)
        }
        .frame(height: 25)
        .cornerRadius(15)
        .padding()
    }
}

#Preview {
    EmotionBarView()
        .environmentObject(ReadingVM())
}
