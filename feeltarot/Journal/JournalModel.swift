//
//  JournalModel.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//

import Foundation


struct AiResponse: Decodable {
    let emotion: String
    let answer: String
}

let emotions: [String: [String]] = [
    "Negative and forceful": ["Anger", "Annoyance", "Contempt", "Disgust", "Irritation"],
    "Negative and not in control": ["Anxiety", "Embarrassment", "Fear", "Helplessness", "Powerlessness", "Worry"],
    "Negative thoughts": ["Doubt", "Envy", "Frustration", "Guilt", "Shame"],
    "Negative and passive": ["Boredom", "Despair", "Disappointment", "Hurt", "Sadness", "Agitation", "Stress", "Shock", "Tension"],
    "Positive and lively": ["Amusement", "Delight", "Elation", "Excitement", "Happiness", "Joy", "Pleasure"],
    "Caring": ["Affection", "Empathy", "Friendliness", "Love"],
    "Positive thoughts": ["Pride", "Courage", "Hope", "Humility", "Satisfaction", "Trust"],
    "Quiet positive": ["Calmness", "Contentment", "Relaxation", "Relief", "Serenity"],
    "Reactive": ["Interest", "Politeness", "Surprise"]
]
