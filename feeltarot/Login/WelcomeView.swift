//
//  LoginView.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var loginVM: LoginVM
    
    @State private var showLine1 = false
    @State private var showLine2 = false
    @State private var showLine3 = false
    @State private var showLine4 = false
    
    var body: some View {
        ZStack {
            Image("background-0")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 12) {
                    Spacer()
                    
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
                    if loginVM.isCreateAccount == false {
                        LoginView()
                    } else {
                        CreateAccountView()
                    }
                }
            }
            .padding()
            .padding(.vertical)
            .task {
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
    }
}

#Preview {
    WelcomeView()
        .environmentObject(LoginVM())
}


