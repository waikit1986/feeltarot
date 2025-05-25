//
//  JournalModel.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//

import Foundation

struct Feeling: Identifiable {
    let id: Int
    let text: String
    let temperature: String
}

let feelingData: [(text: String, temperature: String)] = [
    ("Happiness", "positive"),
    ("Sadness", "negative"),
    ("Fear", "negative"),
    ("Anger", "negative"),
    ("Surprise", "neutral"),
    ("Disgust", "negative"),
    
    ("other feelings", "")
]

let feelings: [Feeling] = feelingData.enumerated().map { (index, data) in
    Feeling(id: index, text: data.text, temperature: data.temperature)
}
