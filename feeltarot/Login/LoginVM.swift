//
//  LoginVM.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import Foundation
import SwiftUI

class LoginVM: ObservableObject {
    @EnvironmentObject var homeVM: HomeVM
    
    // MARK: - Create Account & Login
    
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func createAccount() async throws {
        guard let url = URL(string: "https://feeltarot.com/api/user") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let userData = CreateUser(username: username, email: email, password: password)

        request.httpBody = try JSONEncoder().encode(userData)

        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                errorMessage = serverError.detail
                await MainActor.run {
                    self.isLoading = false
                }
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: serverError.detail])
            } else {
                errorMessage = String(httpResponse.statusCode)
                await MainActor.run {
                    self.isLoading = false
                }
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error \(httpResponse.statusCode)"])
            }
        }

        let user = try JSONDecoder().decode(UserDisplay.self, from: data)
        await MainActor.run {
            print("✅ Created user: \(user)")
        }

        await MainActor.run {
            self.isLoading = false
        }
    }
    
    func login() async throws {
        guard let url = URL(string: "https://feeltarot.com/api/token") else {
            let message = "Invalid URL"
            await MainActor.run {
                self.errorMessage = message
                self.isLoading = false
            }
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParams = [
            "username": username,
            "password": password
        ]
        let bodyString = bodyParams.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                let message = "Invalid server response"
                await MainActor.run {
                    self.errorMessage = message
                    self.isLoading = false
                }
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage: String
                if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                    errorMessage = serverError.detail
                } else {
                    errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                }

                await MainActor.run {
                    self.errorMessage = "Server error: \(errorMessage)"
                    self.isLoading = false
                }

                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)

            await MainActor.run {
                if let tokenData = decoded.access_token.data(using: .utf8),
                   let userIdData = decoded.user_id.data(using: .utf8),
                   let usernameData = decoded.username.data(using: .utf8),
                   let emailData = decoded.email.data(using: .utf8),
                   let passwordData = password.data(using: .utf8) {
                    
                    KeychainHelper.standard.save(tokenData, service: tokenService, account: accessTokenAccount)
                    KeychainHelper.standard.save(userIdData, service: tokenService, account: userIdAccount)
                    KeychainHelper.standard.save(usernameData, service: tokenService, account: usernameAccount)
                    KeychainHelper.standard.save(emailData, service: tokenService, account: emailAccount)
                    KeychainHelper.standard.save(passwordData, service: tokenService, account: passwordAccount)
                    
                    print("✅ All credentials saved to Keychain")
                }
                self.isLoading = false
            }

        } catch {
            let message = "Network error: \(error.localizedDescription)"
            await MainActor.run {
                self.errorMessage = message
                self.isLoading = false
            }
            throw NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }
    
    // MARK: - Credentials operation
    
    @Published var isRegistered: Bool = false
    
    let tokenService = "feeltarot"
    let accessTokenAccount = "accessToken"
    let userIdAccount = "userId"
    let usernameAccount = "username"
    let emailAccount = "email"
    let passwordAccount = "password"
    
    func checkStoredCredentials() {
        let hasToken = KeychainHelper.standard.read(service: tokenService, account: accessTokenAccount) != nil
        let hasUsername = KeychainHelper.standard.read(service: tokenService, account: usernameAccount) != nil
        let hasPassword = KeychainHelper.standard.read(service: tokenService, account: passwordAccount) != nil
        
        isRegistered = hasToken && hasUsername && hasPassword
    }
    
    func getStoredCredentials() {
        if let emailData = KeychainHelper.standard.read(service: tokenService, account: emailAccount),
           let storedEmail = String(data: emailData, encoding: .utf8) {
            email = storedEmail
        }

        if let usernameData = KeychainHelper.standard.read(service: tokenService, account: usernameAccount),
           let storedUsername = String(data: usernameData, encoding: .utf8) {
            username = storedUsername
        }

        if let passwordData = KeychainHelper.standard.read(service: tokenService, account: passwordAccount),
           let storedPassword = String(data: passwordData, encoding: .utf8) {
            password = storedPassword
            confirmPassword = storedPassword
        }
    }
    
    func deleteToken() {
        KeychainHelper.standard.delete(service: tokenService, account: accessTokenAccount)
    }
    
    // MARK: - ReLogin
    
    func reLogin() async {
        guard let usernameData = KeychainHelper.standard.read(service: tokenService, account: usernameAccount),
              let passwordData = KeychainHelper.standard.read(service: tokenService, account: passwordAccount),
              let storedUsername = String(data: usernameData, encoding: .utf8),
              let storedPassword = String(data: passwordData, encoding: .utf8),
              let url = URL(string: "https://feeltarot.com/api/token") else {
            print("❌ Missing stored credentials or invalid URL")
            return
        }
        
        guard let _ = KeychainHelper.standard.read(service: tokenService, account: accessTokenAccount) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = [
            "username": storedUsername,
            "password": storedPassword
        ]
        let bodyString = bodyParams.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }
            
            let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
            
            await MainActor.run {
                if let tokenData = decoded.access_token.data(using: .utf8),
                   let userIdData = decoded.user_id.data(using: .utf8),
                   let usernameData = decoded.username.data(using: .utf8),
                   let emailData = decoded.email.data(using: .utf8),
                   let passwordData = storedPassword.data(using: .utf8) {
                    
                    KeychainHelper.standard.save(tokenData, service: tokenService, account: accessTokenAccount)
                    KeychainHelper.standard.save(userIdData, service: tokenService, account: userIdAccount)
                    KeychainHelper.standard.save(usernameData, service: tokenService, account: usernameAccount)
                    KeychainHelper.standard.save(emailData, service: tokenService, account: emailAccount)
                    KeychainHelper.standard.save(passwordData, service: tokenService, account: passwordAccount)
                    
                    print("✅ Re-login successful. Credentials refreshed.")
                }
                // TODO: trigger post-login actions if needed
            }
            
        } catch {
            if let serverError = try? JSONDecoder().decode(ServerError.self, from: (error as NSError).userInfo[NSUnderlyingErrorKey] as? Data ?? Data()) {
                await MainActor.run {
                    self.errorMessage = serverError.detail
                }
            } else {
                await MainActor.run {
                    self.errorMessage = "Unidentified error occurred"
                }
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    // MARK: - Update user
    
    @Published var isDeleteUser = false
    @Published var hasDeletedAccount = false
    
    func updateUser() async {
        guard let url = URL(string: "https://feeltarot.com/api/user/\(username)") else {
            await MainActor.run { self.errorMessage = "Invalid URL" }
            return
        }

        guard var request = AuthorizationBearerBuilder.build(url: url, method: "PUT") else {
            print("❌ Failed to build request")
            return
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let userData = CreateUser(username: username, email: email, password: password)

        do {
            request.httpBody = try JSONEncoder().encode(userData)
        } catch {
            await MainActor.run { self.errorMessage = "Failed to encode user data." }
            return
        }

        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                    await MainActor.run {
                        self.errorMessage = serverError.detail
                    }
                } else {
                    await MainActor.run {
                        self.errorMessage = "Server error: \(httpResponse.statusCode)"
                    }
                }
                return
            }

            if let responseStr = String(data: data, encoding: .utf8) {
                print("✅ Server response: \(responseStr)")
            }

            Task {
                try await login()
            }

        } catch {
            await MainActor.run {
                self.errorMessage = "Something went wrong: \(error.localizedDescription)"
            }
        }

        await MainActor.run {
            self.isLoading = false
        }
    }
    
    // MARK: - Delete User
    
    func deleteUser() async throws {
        guard let url = URL(string: "https://feeltarot.com/api/user") else {
            let message = "Invalid URL"
            await MainActor.run {
                self.errorMessage = message
                self.isDeleteUser = false
            }
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
        }

        guard var request = AuthorizationBearerBuilder.build(url: url, method: "DELETE") else {
            let message = "Failed to build request"
            await MainActor.run {
                self.errorMessage = message
                self.isDeleteUser = false
            }
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                let message = "Invalid HTTP response"
                await MainActor.run {
                    self.errorMessage = message
                    self.isDeleteUser = false
                }
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
            }

            if (200...299).contains(httpResponse.statusCode) {
                if let result = String(data: data, encoding: .utf8) {
                    print("✅ Delete response: \(result)")
                }

                await MainActor.run {
                    self.errorMessage = nil
                    self.hasDeletedAccount = true
                    self.isDeleteUser = false
                }

            } else {
                let message: String
                if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                    message = serverError.detail
                } else {
                    message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                }

                await MainActor.run {
                    self.errorMessage = "Server error: \(message)"
                    self.isDeleteUser = false
                }

                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
            }

        } catch {
            let message = "Network error: \(error.localizedDescription)"
            await MainActor.run {
                self.errorMessage = message
                self.isDeleteUser = false
            }

            throw NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }
    
    // MARK: - Get Username Info
    
    func getUsername() async {
        guard let usernameData = KeychainHelper.standard.read(service: tokenService, account: usernameAccount),
              let username = String(data: usernameData, encoding: .utf8) else {
            print("⚠️ No username found in Keychain")
            return
        }
        
        guard let url = URL(string: "https://feeltarot.com/api/user/\(username)") else {
            print("❌ Invalid URL")
            return
        }
        
        guard let request = AuthorizationBearerBuilder.build(url: url, method: "GET") else {
            print("❌ Failed to build authorized request")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("✅ User Info: \(json)")
            
        } catch {
            if let serverError = try? JSONDecoder().decode(ServerError.self, from: (error as NSError).userInfo[NSUnderlyingErrorKey] as? Data ?? Data()) {
                print("❌ Server error: \(serverError.detail)")
            } else {
                print("❌ Unexpected error decoding response: \(error)")
            }
        }
    }
    
    // MARK: - Filter user name input
    
    func filterUsernameInput() {
        username = String(
            username
                .filter { $0.isLetter || $0.isNumber }
                .prefix(20)
        )
    }
    
    // MARK: - Timer to relogin
    
    @Published var elapsedSeconds: Int = 0
    private var timer: Timer?
    private let maxSeconds = 29 * 60
    
    func startRepeatingTimer() {
        stopTimer()
        elapsedSeconds = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.elapsedSeconds += 1
            
            if self.elapsedSeconds >= self.maxSeconds {
                self.timerDidReachLimit()
                self.elapsedSeconds = 0
            }
        }
        
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func timerDidReachLimit() {
        print("⏰ Timer reached 29 minutes. Triggering action...")
        
        Task {
            await reLogin()
        }
    }
    
}
