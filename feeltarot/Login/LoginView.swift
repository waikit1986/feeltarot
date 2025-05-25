//
//  LoginView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var showLine1 = false
    @State private var showLine2 = false
    @State private var showLine3 = false
    @State private var showLine4 = false

    var body: some View {
        ZStack {
            Image("girlReadingBook")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Spacer()
                
                Spacer()
                
                VStack(spacing: 12) {
                    if showLine1 {
                        Text("Feel Tarot")
                            .font(.largeTitle).bold()
                            .foregroundStyle(.white)
                            .transition(.opacity)
                    }
                    if showLine2 {
                        Text("journaling")
                            .font(.largeTitle).bold()
                            .foregroundStyle(.white)
                            .transition(.opacity)
                    }
                    if showLine3 {
                        Text("your emotion")
                            .font(.largeTitle).bold()
                            .foregroundStyle(.white)
                            .transition(.opacity)
                    }
                }
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                
                if showLine4 {
                    AppleSignInButton()
                }
                
                Spacer()
            }
            .padding()
            .padding(.vertical)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    showLine1 = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeIn(duration: 1.0)) {
                        showLine2 = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeIn(duration: 1.0)) {
                        showLine3 = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeIn(duration: 1.0)) {
                        showLine4 = true
                    }
                }
            }
        }
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

#Preview {
    LoginView()
}

//VStack() {
//    Spacer()
//    
//    Text("Login")
//        .font(.largeTitle)
//        .bold()
//    
//    TextField("Username", text: $loginVM.username)
//        .autocapitalization(.none)
//        .padding()
//        .background(Color(.secondarySystemBackground))
//        .cornerRadius(12)
//    
//    SecureField("Password", text: $loginVM.password)
//        .padding()
//        .background(Color(.secondarySystemBackground))
//        .cornerRadius(12)
//    
//    if let errorMessage = loginVM.errorMessage {
//        Text(errorMessage)
//            .foregroundColor(.red)
//            .multilineTextAlignment(.center)
//    }
//    
//    Button(action: loginVM.login) {
//        if loginVM.isLoading {
//            ProgressView()
//                .frame(maxWidth: .infinity)
//                
//        } else {
//            Text("Sign In")
//                .frame(maxWidth: .infinity)
//        }
//    }
//    .disabled(loginVM.username.isEmpty || loginVM.password.isEmpty || loginVM.isLoading)
//    .padding()
//    .background(Color("AccentColor"))
//    .foregroundColor(.black)
//    .cornerRadius(12)
//    
//    if keyboard.isKeyboardVisible {
//        Spacer()
//    }
//}
//.frame(width: UIScreen.main.bounds.width * 0.8)
//.padding()
//.padding(.vertical, 50)
//.animation(.spring(response: 1.0, dampingFraction: 0.6, blendDuration: 0.2), value: keyboard.isKeyboardVisible)
