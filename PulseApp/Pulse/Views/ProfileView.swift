//
//  ProfileView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 04/02/2026.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("dailyMoodReminderEnabled") private var dailyMoodReminderEnabled = true
    @AppStorage("themePreference") private var themePreference: String = "auto"
    @AppStorage("userName") private var userName: String = "User"
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    ZStack {
                        LinearGradient(
                            colors: [Color.blue.opacity(0.75), Color.purple.opacity(0.70)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        VStack(spacing: 10) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 82))
                                .foregroundColor(.white)
                            
                            Text(userName)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("Your quiet wellness space")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    }
                    .frame(height: 250)
                    .padding(.bottom, 16)
                    
                    VStack(spacing: 18) {
                        
                        // Notifications
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Notifications")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Toggle("Daily Mood Reminder", isOn: $dailyMoodReminderEnabled)
                        }
                        .padding()
                        .background(Color.white.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                        
                        // Preferences
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Preferences")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text("Theme")
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Picker("", selection: $themePreference) {
                                    Text("Auto").tag("auto")
                                    Text("Light").tag("light")
                                    Text("Dark").tag("dark")
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                        
                        // About
                        VStack(alignment: .leading, spacing: 10) {
                            Text("About")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Pulse is designed to support emotional awareness through mood check-ins, guided breathing, journaling, and gentle self-care tools.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                        
                        //signout button
                        Button("Sign Out"){
                            signOut()
                        }
                        .padding(.top,20)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(colorSchemeFromPreference(themePreference))
        
    }
    
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
    }
    
    private func colorSchemeFromPreference(_ pref: String) -> ColorScheme? {
        switch pref {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
