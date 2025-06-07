//
//  ReadingVM.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/5/25.
//

import Foundation
import SwiftUI

@MainActor
class ReadingVM: ObservableObject {
    @Published var readingList: [ReadingResponse]? = nil
    
    func getAllReadings() async {
        guard let url = URL(string: "https://feeltarot.com/api/reading") else {
            print("❌ Invalid URL")
            return
        }
        
        guard let request = AuthorizationBearerBuilder.build(
            url: url,
            method: "GET"
        ) else {
            print("❌ Failed to build request")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                    print("❌ reading Server error: \(serverError.detail)")
                } else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    print("❌ reading Server error: \(message)")
                }
                return
            }
            
            let decoder = JSONDecoder()

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(formatter)

            let decoded = try decoder.decode([ReadingResponse].self, from: data)

            DispatchQueue.main.async {
                self.readingList = decoded.sorted { $0.createdAt < $1.createdAt }
                self.emotionPercentage()
            }
        } catch {
            print("❌ Network or decoding error: \(error.localizedDescription)")
        }
    }
    
    @Published var cardNumber: Int? = nil
    
    func getCardNumber(cardName: String) {
        cardNumber = tarotCardNames.first(where: { $0.value == cardName })?.key
    }
    
    func findCategory(emotion: String) -> String {
        for (category, emotionsList) in emotions {
            if emotionsList.contains(emotion) {
                return category
            }
        }
        return "Unknown"
    }
    
    func colorForCategory(emotion: String) -> Color {
        let category = findCategory(emotion: emotion)
        if category.contains("Negative") {
            return .indigo.opacity(0.8)
        } else {
            return .accent.opacity(0.8)
        }
    }
    
    @Published var positiveEmotion: Double = 0
    @Published var negativeEmotion: Double = 0

    func emotionPercentage() {
        guard let readingList = readingList, !readingList.isEmpty else {
            positiveEmotion = 0
            negativeEmotion = 0
            return
        }
        
        var negativeCount = 0
        var nonNegativeCount = 0
        
        for reading in readingList {
            let emotion = reading.emotion
            
            let category = findCategory(emotion: emotion)
            if category.contains("Negative") {
                negativeCount += 1
            } else {
                nonNegativeCount += 1
            }
        }
        
        let total = negativeCount + nonNegativeCount
        guard total > 0 else {
            positiveEmotion = 0
            negativeEmotion = 0
            return
        }
        
        negativeEmotion = Double(negativeCount) / Double(total)
        positiveEmotion = Double(nonNegativeCount) / Double(total)
    }

}
