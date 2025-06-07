//
//  HomeViewModel.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import Foundation
import SwiftUI

class HomeVM: ObservableObject {
        
    @Published var selection = 3
    
    func checkKeychainIsEmpty() {
//        if let userIdData = KeychainHelper.standard.read(service: "feeltarot", account: "userId"), let _ = String(data: userIdData, encoding: .utf8) {
//            selection = 0
//        }
        
        if let tokenData = KeychainHelper.standard.read(service: "feeltarot", account: "accessToken"), let _ = String(data: tokenData, encoding: .utf8) {
            selection = 0
        } else {
            selection = 3
        }
    }
}
