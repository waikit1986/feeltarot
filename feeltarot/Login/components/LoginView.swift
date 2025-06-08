//
//  LoginView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/27/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var loginVM: LoginVM
    
    var body: some View {
        VStack {
            TextField("Username", text: $loginVM.username)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .onChange(of: loginVM.username) {
                    loginVM.filterUsernameInput()
                }
            
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
                    do {
                        try await loginVM.login()
                        homeVM.selection = 0
                    } catch {
                        print(loginVM.errorMessage as Any)
                    }
                }
            }label: {
                if loginVM.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                    
                } else {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(loginVM.username.isEmpty || loginVM.password.isEmpty || loginVM.isLoading)
            .padding()
            .background(Color("AccentColor"))
            .foregroundColor(.black)
            .cornerRadius(12)
            
            Text("Create Account")
                .onTapGesture {
                    homeVM.isKeychainExist = false
                }
                .padding()
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .padding()
        .onAppear {
            loginVM.getStoredCredentials()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginVM())
}
