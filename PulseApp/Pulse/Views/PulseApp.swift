//
//  PulseApp.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 02/02/2026.
//
import SwiftUI
import Firebase
import FirebaseAuth

@main
struct PulseApp: App {
    
    @State private var isLoggedIn = false
    
    init() {
        FirebaseApp.configure()
        isLoggedIn = Auth.auth().currentUser != nil
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    ContentView()
                } else {
                    WelcomeView()
                }
            }
            .onAppear {
                Auth.auth().addStateDidChangeListener { _, user in
                    isLoggedIn = (user != nil)
                }
            }
        }
    }
}
