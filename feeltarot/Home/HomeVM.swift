//
//  HomeViewModel.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import Foundation
import SwiftUI
import Supabase

class HomeVM: ObservableObject {
    
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://obrjbqfiybdzqbfpdqrq.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9icmpicWZpeWJkenFiZnBkcXJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgwODU0MzMsImV4cCI6MjA2MzY2MTQzM30.ysTyb_VMM909kLTr-nrO3sIuKLqGpEFHLBzyj5y-h14")
    
    var session: Session?
    
    init() {
        Task {
            await initializeSupabaseSession()
        }
    }
    
    private func initializeSupabaseSession() async {
        do {
            self.session = try await supabase.auth.session
            print("Success: Supabase Session initializated")
        } catch {
            print("Failed: Supabase Session: \(error)")
        }
    }
    
    func signOutSupabaseSession() async {
        do {
            try await supabase.auth.signOut()
            print("Sucess: Supabase session signout")
        } catch {
            print("Failed: Supabase session signout: \(error)")
        }
    }
    
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
}
