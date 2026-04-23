//
//  WelcomeView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 11/04/2026.


import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationStack {
           
            ZStack {
                
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                        .frame(height: 80)
                    
                   
                    Circle()
                        .fill(Color.white.opacity(0.85))
                        .frame(width: 90, height: 90)
                        .overlay(
                            Text("💙")
                                .font(.system(size: 40))
                        )
                    
                    Spacer()
                        .frame(height: 35)
                    
                    // App name
                    Text("Pulse")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Subtitle
                    Text("your mental wellness companion")
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 8)
                    
                    Spacer()
                        .frame(height: 100)
                    
                    // Feature list
                    VStack(alignment: .leading, spacing: 28) {
                        Text("🙂 Track your mood daily")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Text("🧘 Practice mindfulness exercises")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Text("📊 Understand your patterns")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    // Navigationlink moves to the signup page
                    NavigationLink(destination:SignUpView()){
                    
                        Text("Get Started")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .cornerRadius(16)
                            .font(.title3)
                    }
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 40)
            }
            .toolbar(.hidden, for: .navigationBar)   
        }
    }
}

#Preview {
    WelcomeView()
}
