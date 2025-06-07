//
//  ReadingModel.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/5/25.
//

import Foundation

struct ReadingResponse: Codable, Identifiable {
    let id: UUID
    let createdAt: Date
    let card: String
    let situation: String
    let emotion: String
    let answer: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case card
        case situation
        case emotion
        case answer
    }
}
