//
//  JournalVM.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/31/25.
//

import Foundation

@MainActor
class JournalVM: ObservableObject {
    
    @Published var isShowingTextField = true
    @Published var isShowingCardView = false
    
    @Published var isLoading = false
    
    @Published var card = ""
    @Published var situation = ""
    @Published var answer = ""
    @Published var emotion = ""
    
    func sendAIRequest() async {
        guard let url = URL(string: "https://feeltarot.com/api/ai") else {
            print("❌ Invalid URL")
            return
        }

        let jsonBody: [String: Any] = [
            "card": card,
            "situation": situation
        ]

        guard let request = AuthorizationBearerBuilder.build(
            url: url,
            method: "POST",
            jsonBody: jsonBody
        ) else {
            print("❌ Failed to build request")
            return
        }

        do {
            isLoading = true

            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                    print("❌ Server error: \(serverError.detail)")
                } else {
                    let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    print("❌ Server error: \(message)")
                }
                return
            }
            
            let decoded = try JSONDecoder().decode(AiResponse.self, from: data)

            DispatchQueue.main.async {
                self.emotion = decoded.emotion
                self.answer = decoded.answer
                self.isLoading = false
            }
        } catch {
            print("❌ Network or decoding error: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    @Published var randomBackground = 0
    @Published var randomCard: Int? = nil
    
    func randomNumberBackground() {
        randomBackground = Int.random(in: 0...3)
    }
    
    func randomNumberCard() {
        let number = Int.random(in: 0...77)
        randomCard = number
        card = tarotCardNames[number] ?? ""
    }
    
    @Published var progress: Double = 0.0
    @Published var progressTimer: Timer?
    @Published var statusTimer: Timer?
    @Published var statusText: String = "Analyzing Card Imagery…"
    @Published var statusIndex = 0
    
    let statusMessages = [
        "Analyzing Card Imagery...",
        "Reading Symbols and Pattern...",
        "Analyzing your situation...",
        "Receiving Insights..."
    ]
    
    func startProgressView() {
        progress = 0.0
        progressTimer?.invalidate()
        
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] t in
            guard let self = self else {
                t.invalidate()
                return
            }

            Task { @MainActor in
                if self.progress >= 1.0 {
                    t.invalidate()
                    self.progressTimer = nil
                } else {
                    self.progress = min(self.progress + 0.005, 1.0)
                }
            }
        }
    }
    
    func startStatusRotation() {
        statusTimer?.invalidate()
        statusIndex = 0
        statusText = statusMessages[statusIndex]

        statusTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] t in
            guard let self = self else {
                t.invalidate()
                return
            }

            Task { @MainActor in
                if self.statusIndex < self.statusMessages.count - 1 {
                    self.statusIndex += 1
                    self.statusText = self.statusMessages[self.statusIndex]
                } else {
                    t.invalidate()
                    self.statusTimer = nil
                }
            }
        }
    }
    
    func tappedJournalButton() {
        isShowingCardView = true
    }
    
    func cancelJournalButton() {
        situation = ""
        isShowingCardView = false
    }

    func tappedCardView() {
        randomNumberCard()
        Task {
            isShowingTextField = false
            startProgressView()
            startStatusRotation()
            await sendAIRequest()
        }
    }
    
    func tappedCardAnswerView() {
        isShowingCardView = false
        isShowingTextField = true
        randomCard = nil
        card = ""
        situation = ""
        answer = ""
        emotion = ""
    }
}
