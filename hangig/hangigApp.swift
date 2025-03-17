//
//  hangigApp.swift
//  hangig
//
//  Created by Bailey Jones on 3/17/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn

@main
struct hangigApp: App {
    
    init() {
        // Load GoogleService-Info-2.plist manually
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info-2", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else {
            print("⚠️ Error: GoogleService-Info-2.plist not found!")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
