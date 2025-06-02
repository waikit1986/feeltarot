////
////  AppleSignInButton.swift
////  feeltarot
////
////  Created by Low Wai Kit on 5/25/25.
////
//
//
//import SwiftUI
//import AuthenticationServices
//import Supabase
//
//struct AppleSignInButton: View {
//    
//    @Environment(\.colorScheme) var colorScheme
//    @EnvironmentObject var userManager: UserManager
//    @EnvironmentObject var homeVM: HomeVM
//    
//    @StateObject private var signInHandler = SignInHandler()
//    
//    var body: some View {
//        VStack {
//            Button(action: {
//                signInHandler.startAppleSignIn(userManager: userManager, homeVM: homeVM)
//            }) {
//                HStack {
//                    Image(systemName: "applelogo")
//                        .font(.headline)
//                    Text("Sign in with Apple")
//                        .fontWeight(.semibold)
//                }
//                .foregroundColor(.black)
//                .frame(width: 200, height: 45)
//                .background(Color("AccentColor"))
//                .cornerRadius(12)
//                .shadow(color: colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.3), radius: 10)
//            }
//        }
//    }
//}
//
//final class SignInHandler: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//    
//    private var userManager: UserManager?
//    private var homeVM: HomeVM?
//    
//    func startAppleSignIn(userManager: UserManager, homeVM: HomeVM) {
//        self.userManager = userManager
//        self.homeVM = homeVM
//        
//        let request = ASAuthorizationAppleIDProvider().createRequest()
//        request.requestedScopes = [.email, .fullName]
//        
//        let controller = ASAuthorizationController(authorizationRequests: [request])
//        controller.delegate = self
//        controller.presentationContextProvider = self
//        controller.performRequests()
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        Task {
//            guard let homeVM = homeVM,
//                  let userManager = userManager,
//                  let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
//                  let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
//                return
//            }
//            
//            do {
//                _ = try await homeVM.supabase.auth.signInWithIdToken(
//                    credentials: .init(provider: .apple, idToken: idToken)
//                )
//                
//                if let user = try? await homeVM.supabase.auth.session.user {
//                    userManager.id = user.id
//                    homeVM.session = try? await homeVM.supabase.auth.session
//                    print("userManager.id saved: \(String(describing: userManager.id))")
//                }
//            } catch {
//                dump(error)
//            }
//        }
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Apple Sign-In failed: \(error)")
//    }
//    
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        UIApplication.shared.connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .flatMap { $0.windows }
//            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
//    }
//}
//
//#Preview {
//    AppleSignInButton()
//        .environmentObject(UserManager())
//        .environmentObject(HomeVM())
//}
