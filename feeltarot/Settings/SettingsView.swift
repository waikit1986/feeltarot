//
//  SettingsView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 6/7/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var homeVM: HomeVM
    @EnvironmentObject var loginVM: LoginVM
    @EnvironmentObject var journalVM: JournalVM
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
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
                    .onChange(of: loginVM.username) {
                        loginVM.filterUsernameInput()
                    }
                
                SecureField("Password", text: $loginVM.password)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                
                if loginVM.password != loginVM.confirmPassword {
                    Text("Passwords do not match")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                SecureField("Confirm Password", text: $loginVM.confirmPassword)
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
                        await loginVM.updateUser()
                    }
                }label: {
                    if loginVM.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                        
                    } else {
                        Text("Submit Changes")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(
                    loginVM.username.isEmpty ||
                    loginVM.email.isEmpty ||
                    loginVM.password.isEmpty ||
                    loginVM.confirmPassword.isEmpty ||
                    loginVM.password != loginVM.confirmPassword ||
                    loginVM.isLoading
                )
                .padding()
                .background(Color("AccentColor"))
                .foregroundColor(.black)
                .cornerRadius(12)
                
                Text("Logout")
                    .padding()
                    .onTapGesture {
                        loginVM.deleteToken()
                        homeVM.selection = 3
                    }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            .padding()
            
            HStack {
                Image(systemName: "house")
                    .font(.title)
                    .onTapGesture {
                        homeVM.selection = 0
                    }
                
                Spacer()
                
                Text("delete account")
                    .font(.caption)
                    .foregroundStyle(Color.red)
                    .onTapGesture {
                        Task {
                            loginVM.isDeleteUser = true
                        }
                    }
                
                Spacer()
            }
            .foregroundStyle(Color("AccentColor"))
            .shadow(color: colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8), radius: 10)
            .padding()
        }
        .onAppear {
            loginVM.getStoredCredentials()
        }
        .background {
            BackgroundView()
        }
        .alert("Deleting your Account, will also delete all your saved Readings", isPresented: $loginVM.isDeleteUser) {
            Button("Cancel", role: .cancel) {
                loginVM.isDeleteUser = false
            }
            Button("OK", role: .destructive) {
                Task {
                    do {
                        try await loginVM.deleteUser()
                        loginVM.deleteToken()
                    } catch {
                        print(loginVM.errorMessage as Any)
                    }
                }
            }
        }
        .alert("Your account has been deleted", isPresented: $loginVM.hasDeletedAccount) {
            Button("OK", role: .cancel) {
                loginVM.hasDeletedAccount = false
                homeVM.selection = 3
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(HomeVM())
        .environmentObject(LoginVM())
        .environmentObject(JournalVM())
}
