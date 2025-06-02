//
//  AuthorizedRequestBuilder.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/25/25.
//


import Foundation

struct AuthorizationBearerBuilder {
    private static let tokenService = "feeltarot"
    private static let accessTokenAccount = "accessToken"

    static func build(
        url: URL,
        method: String = "GET",
        jsonBody: [String: Any]? = nil
    ) -> URLRequest? {
        guard let tokenData = KeychainHelper.standard.read(service: tokenService, account: accessTokenAccount),
              let token = String(data: tokenData, encoding: .utf8) else {
            print("⚠️ No access token found in Keychain")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = jsonBody {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("❌ Failed to encode JSON body: \(error.localizedDescription)")
                return nil
            }
        }

        return request
    }
}
