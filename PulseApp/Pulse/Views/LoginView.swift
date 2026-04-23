//
//  LoginView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 11/04/2026.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @AppStorage("userName") private var userName: String = ""
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                Spacer()
                    .frame(height: 80)
                
                // Maintitle
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Subtitle
                Text("Log in to continue your wellness journey")
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 5)
                
                Spacer()
                    .frame(height: 60)
                //email
                Text("Email")
                    .foregroundColor(.white)
                
                TextField("your@email.com", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                // password
                Text("Password")
                    .foregroundColor(.white)
    
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // login
                Button {
                    loginUser()
                } label: {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                        .font(.title3)
                }
                
                // signup
                HStack {
                    Spacer()
                    
                    Text("Don’t have an account?")
                        .foregroundColor(.white.opacity(0.9))
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(30)
        }
        .toolbar(.hidden, for: .navigationBar)
        
        // Shows error if login fails
        .alert("Login Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    func loginUser() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty else {
            errorMessage = "Please enter your email."
            showError = true
            return
        }
        guard !trimmedPassword.isEmpty else {
            errorMessage = "Please enter your password."
            showError = true
            return
        }
        
        Auth.auth().signIn(withEmail: trimmedEmail, password: trimmedPassword) {_, error in
            
            if error != nil {
                errorMessage = "Invalid email or password. Please try again."
                showError = true
                return
            }
            if let firebaseName = Auth.auth().currentUser?.displayName, !firebaseName.isEmpty {
                userName = firebaseName
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
