//
//  ReadingListView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/5/25.
//

import SwiftUI

struct ReadingListView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var readingVM: ReadingVM
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    if let readings = readingVM.readingList {
                        ForEach(readings) { reading in
                            VStack {
                                NavigationLink(destination: ReadingView(reading: reading)) {
                                    HStack {
                                        Text(reading.emotion)
                                            .fontWeight(.semibold)
                                            .padding(.trailing)
                                        
                                        Spacer()
                                        
                                        Text(reading.situation)
                                            .multilineTextAlignment(.trailing)
                                            .lineLimit(3)
                                            .truncationMode(.tail)
                                    }
                                    .foregroundStyle(Color("TextColor"))
                                    .padding()
                                    .background {
                                        readingVM.colorForCategory(emotion: reading.emotion)
                                            .cornerRadius(15)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .id(reading.id)
                        }
                    }
                    
                    if readingVM.readingList == nil {
                        Text("You have no Readings done")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                .onAppear {
                    Task {
                        await readingVM.getAllReadings()
                    }
                }
                
                if readingVM.readingList != nil {
                    EmotionBarView()
                }
                
                HStack {
                    Image(systemName: "house")
                        .font(.title)
                        .onTapGesture {
                            homeVM.selection = 0
                        }
                    
                    Spacer()
                }
                .foregroundStyle(Color("AccentColor"))
                .shadow(color: colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8), radius: 10)
                .padding()
            }
            .background {
                BackgroundView()
            }
        }
    }
}

#Preview {
    ReadingListView()
        .environmentObject(HomeVM())
        .environmentObject(ReadingVM())
}
