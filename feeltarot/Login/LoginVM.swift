//
//  LoginVM.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import Foundation

class LoginVM: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    let tokenService = "feeltarot"
    let accessTokenAccount = "accessToken"
    let userIdAccount = "userId"
    let usernameAccount = "username"
    let emailAccount = "email"
    let passwordAccount = "password"
    
    func login() {
        guard let url = URL(string: "https://feeltarot.com/api/token") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

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

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            do {
                let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)

                DispatchQueue.main.async {
                    if let tokenData = decoded.access_token.data(using: .utf8),
                       let userIdData = decoded.user_id.data(using: .utf8),
                       let usernameData = decoded.username.data(using: .utf8),
                       let emailData = decoded.email.data(using: .utf8),
                       let passwordData = self.password.data(using: .utf8)
                    {
                        KeychainHelper.standard.save(tokenData, service: self.tokenService, account: self.accessTokenAccount)
                        KeychainHelper.standard.save(userIdData, service: self.tokenService, account: self.userIdAccount)
                        KeychainHelper.standard.save(usernameData, service: self.tokenService, account: self.usernameAccount)
                        KeychainHelper.standard.save(emailData, service: self.tokenService, account: self.emailAccount)
                        KeychainHelper.standard.save(passwordData, service: self.tokenService, account: self.passwordAccount)

                        print("✅ All credentials saved to Keychain")
                    }
                    // TODO: Navigate to main screen here
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
