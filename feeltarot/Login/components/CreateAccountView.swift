//
//  CreateAccountView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/27/25.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject var loginVM: LoginVM
    
    var body: some View {
        VStack {
            TextField("email", text: $loginVM.email)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            TextField("username", text: $loginVM.username)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            SecureField("Password", text: $loginVM.password)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            
            if let errorMessage = loginVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                Task {
                    await loginVM.createAccount()
                }
            }label: {
                if loginVM.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                    
                } else {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(loginVM.username.isEmpty || loginVM.password.isEmpty || loginVM.isLoading)
            .padding()
            .background(Color("AccentColor"))
            .foregroundColor(.black)
            .cornerRadius(12)
            
            Text("Login")
                .onTapGesture {
                    loginVM.isCreateAccount = false
                }
                .padding()
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .padding()
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(LoginVM())
}
