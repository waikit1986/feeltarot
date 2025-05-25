//
//  UserManager.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//


import Foundation

@MainActor
class UserManager: ObservableObject {
    
    @Published var id: UUID? = nil {
        didSet {
            if let id = id {
                UserDefaults.standard.set(id.uuidString, forKey: "id")
            } else {
                UserDefaults.standard.removeObject(forKey: "id")
            }
        }
    }
    
    @Published var username: String = "" {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    @Published var age: Int? = nil {
        didSet {
            if let age = age {
                UserDefaults.standard.set(age, forKey: "age")
            } else {
                UserDefaults.standard.removeObject(forKey: "age")
            }
        }
    }
    
    @Published var bio: String = "" {
        didSet {
            UserDefaults.standard.set(bio, forKey: "bio")
        }
    }
    
    init() {
        if let storedID = UserDefaults.standard.string(forKey: "id"),
           let uuid = UUID(uuidString: storedID) {
            id = uuid
        }
        if let storedUsername = UserDefaults.standard.string(forKey: "username") {
            username = storedUsername
        }
        if let storedBio = UserDefaults.standard.string(forKey: "bio") {
            bio = storedBio
        }
        if let storedAge = UserDefaults.standard.object(forKey: "age") as? Int {
            age = storedAge
        }
    }
    
}
