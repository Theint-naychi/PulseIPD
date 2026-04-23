//
//  SignUpView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 11/04/2026.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    // store what the user types
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    // store any error message from Firebase or validation
    @State private var errorMessage = ""
    
    @State private var showError = false
    
    // save the user name on the device ProfileView can show it
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
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Subtitle
                Text("Start your wellness journey")
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 5)
                
                Spacer()
                    .frame(height: 60)
                
                // NAME
                Text("Your Name")
                    .foregroundColor(.white)
                
                // NAME INPUT
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                // Email label
                Text("Email")
                    .foregroundColor(.white)
                
                // Email input
                TextField("your@email.com", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                // PASSWORD
                Text("Password")
                    .foregroundColor(.white)
                
                // Pw input
                SecureField("Create a password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Sign up button
                Button {
                    signUpUser()
                } label: {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                        .font(.title3)
                }
                
                // Login
                HStack {
                    Spacer()
                    
                    Text("Already have an account?")
                        .foregroundColor(.white.opacity(0.9))
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Log in")
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
        
        // Shows error if sign up fails
        .alert("Sign Up Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // creates a real Firebase user
    func signUpUser() {
        
        // remove extra spaces from what user typed
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // check name is not empty
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter your name."
            showError = true
            return
        }
        
        // check email is not empty
        guard !trimmedEmail.isEmpty else {
            errorMessage = "Please enter your email."
            showError = true
            return
        }
        
        // check password not empty
        guard !trimmedPassword.isEmpty else {
            errorMessage = "Please enter your password."
            showError = true
            return
        }
        
        // firebase requires atleast 6 char for password
        guard trimmedPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            showError = true
            return
        }
        
        // this asks Firebase to create the account
        Auth.auth().createUser(withEmail: trimmedEmail, password: trimmedPassword) { result, error in
            
            // if Firebase gives an error, show it
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }
            
            // save the user display name inside Firebase 
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = trimmedName
                changeRequest.commitChanges{ _ in }
            }
        }
    }
}
#Preview {
    NavigationStack {
        SignUpView()
    }
}
    

