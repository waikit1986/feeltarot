//
//  HomeViewModel.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import Foundation
import SwiftUI

class HomeVM: ObservableObject {
        
    @Published var selection = 1
    
    func checkKeychainIsEmpty() {
        if let data = KeychainHelper.standard.read(service: "feeltarot", account: "userId"), let _ = String(data: data, encoding: .utf8) {
            selection = 0
        }
    }
}
