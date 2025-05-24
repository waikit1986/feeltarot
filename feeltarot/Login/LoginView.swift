//
//  LoginView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginVM: LoginVM

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()

            TextField("Username", text: $loginVM.username)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            SecureField("Password", text: $loginVM.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            if let errorMessage = loginVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button(action: loginVM.login) {
                if loginVM.isLoading {
                    ProgressView()
                } else {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(loginVM.username.isEmpty || loginVM.password.isEmpty || loginVM.isLoading)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    
}

#Preview {
    LoginView()
}
