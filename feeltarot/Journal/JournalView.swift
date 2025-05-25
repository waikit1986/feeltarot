//
//  JournalView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//

import SwiftUI

struct JournalView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("what are you feeling right now?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(feelings) { feeling in
                        HStack {
                            Text(feeling.text)
                                .padding(9)
                                .font(.title3)
                                .foregroundStyle(Color.black)
                                .frame(width: UIScreen.main.bounds.width / 1.5)
                                .background {
                                    if feeling.temperature == "positive" {
                                        Color("AccentColor")
                                            .opacity(0.5)
                                    } else if feeling.temperature == "negative" {
                                        Color.pink
                                            .opacity(0.5)
                                    } else {
                                        Color("AccentColor")
                                            .opacity(0.5)
                                    }
                                }
                                .cornerRadius(12)
                                .shadow(color: colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.3), radius: 10)
                        }
                    }
                }
                .padding()
            }
            .frame(height: UIScreen.main.bounds.height * 0.5)
            
            MenuView()
        }
        .background {
            Image("girlHoldingYellowCard")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    JournalView()
}
