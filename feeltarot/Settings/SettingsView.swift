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
                        Text("Submit Changes")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(loginVM.username.isEmpty || loginVM.password.isEmpty || loginVM.isLoading)
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
                
                Text("delete account")
                    .font(.caption)
                    .foregroundStyle(Color.red)
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
    }
}

#Preview {
    SettingsView()
        .environmentObject(HomeVM())
        .environmentObject(LoginVM())
        .environmentObject(JournalVM())
}
