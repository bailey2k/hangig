//
//  ContentView.swift
//  hangig
//
//  Created by Bailey Jones on 3/17/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        VStack {
            if isLoggedIn {
                VStack {
                    Text("Welcome, \(userName)")
                        .font(.title)
                        .padding()

                    Text("Email: \(userEmail)")
                        .foregroundColor(.gray)

                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            } else {
                VStack {
                    Text("time to hangig")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    GoogleSignInButton(action: handleGoogleSignIn)
                        .frame(height: 50)
                        .padding()
                }
            }
        }
        .padding()
    }

    func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Error: Firebase Client ID not found")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController else {
            print("Error: Could not find root view controller")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
            guard let user = signInResult?.user, error == nil else {
                print("Google Sign-In failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            guard let idToken = user.idToken?.tokenString else {
                print("Error: ID Token not found")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In failed: \(error.localizedDescription)")
                    return
                }

                if let firebaseUser = authResult?.user {
                    userName = firebaseUser.displayName ?? "No Name"
                    userEmail = firebaseUser.email ?? "No Email"
                    isLoggedIn = true
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            isLoggedIn = false
            userName = ""
            userEmail = ""
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
