//
//  ReadingAnswerView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/6/25.
//

import SwiftUI

struct ReadingAnswerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var readingVM: ReadingVM
    
    var reading: ReadingResponse
    
    var body: some View {
        VStack {
            Text("You are feeling \(reading.emotion)")
                .font(.title)
                .padding(.bottom)
            Text(reading.answer)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("AnswerBackground"))
        }
        .padding()
    }
}

#Preview {
//    ReadingAnswerView()
//        .environmentObject(JournalVM())
}
