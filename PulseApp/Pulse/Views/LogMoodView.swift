//
//  LogMoodView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 02/02/2026.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LogMoodView: View {
    
    @Binding var lastMood: UserMood?
    
    //screen goes back to homeview
    @Environment(\.dismiss) var dismiss
    @State private var moodValue: Double = 3    //  the slider position
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let moods: [UserMood] = [.sad, .anxious, .angry, .okay, .calm, .good]
    
    //  selected mood from slider value
    private var currentMood: UserMood {
        moods[Int(moodValue)]
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.88, green: 0.93, blue: 0.99),
                    Color(red: 0.93, green: 0.89, blue: 0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Title
                    VStack(spacing: 8) {
                        Text("Mood Check-In")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Take a quiet moment to notice how you feel today.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 10)
                    
                    // Main mood
                    VStack(spacing: 12) {
                        Text(currentMood.emoji)
                            .font(.system(size: 70))
                        
                        Text(currentMood.rawValue)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(moodDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
                    
                    // Slider
                    VStack(alignment: .leading, spacing: 14) {
                        Text("How are you feeling right now?")
                            .font(.headline)
                        
                        Text("Move the slider to choose the mood that feels closest to you.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Slider(value: $moodValue, in: 0...5, step: 1)
                            .tint(sliderColor)
                        
                        HStack {
                            Text("Sad")
                            Spacer()
                            Text("Anxious")
                            Spacer()
                            Text("Angry")
                            Spacer()
                            Text("Okay")
                            Spacer()
                            Text("Calm")
                            Spacer()
                            Text("Good")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
                    
                    // Support message
                    VStack(alignment: .leading, spacing: 8) {
                        Text("A gentle suggestion")
                            .font(.headline)
                        
                        Text(supportMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
                    
                    // Reflection prompt
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reflection Prompt")
                            .font(.headline)
                        
                        Text(reflectionPrompt)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
                    
                    // Save button
                    Button {
                        saveMoodToFirestore()
                    } label: {
                        Text("Save Mood")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(saveButtonColor)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.top, 4)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
        }
        .navigationTitle("Log Mood")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            if let mood = lastMood,
               let index = moods.firstIndex(of: mood){
                moodValue = Double(index)
            }
        }
        .alert("Save Error", isPresented: $showError){
            Button("OK", role: .cancel){ }
        }message: {
            Text(errorMessage)
        }
    }
    
    //save the selected mood to firestore
    func saveMoodToFirestore(){
        
        //make sure that loggedin user exists
        guard let user = Auth.auth().currentUser else{
            errorMessage = "No logged-in user was found."
            showError = true
            return
        }
        //for firestore refernce
        let db = Firestore.firestore()
        
        //create data to save
        let moodData: [String:Any] = [
            "userId": user.uid,
            "mood": currentMood.rawValue,
            "date": Timestamp(date:Date())
        ]
        
        //save mood entry to firestore
        db.collection("moodEntries").addDocument(data:moodData) { error in
            
            if let error = error {
                errorMessage = error.localizedDescription
                print("Firestore save error: \(error.localizedDescription)")
                showError = true
            } else {
                lastMood = currentMood
                dismiss()
            }
        
        }
        
    }
    
    //current mood desc
    var moodDescription: String {
        switch currentMood {
        case .sad:
            return "Today may feel a little heavy. That is okay."
        case .anxious:
            return "You may be feeling tense or overwhelmed right now."
        case .angry:
            return "You may be feeling frustrated or emotionally tense right now."
        case .okay:
            return "You seem to be doing alright at the moment."
        case .calm:
            return "You seem peaceful and steady right now."
        case .good:
            return "You seem to be feeling positive and uplifted."
        }
    }
    
    //  gives a support message for the selected mood
    var supportMessage: String {
        switch currentMood {
        case .sad:
            return "A short journal entry or grounding exercise may help you release some of what you’re carrying."
        case .anxious:
            return "A slow breathing exercise could help calm your body and mind."
        case .angry:
            return "A pause, deep breathing, or stepping away for a moment may help you cool down safely."
        case .okay:
            return "A quick mindful pause may help you stay balanced for the rest of the day."
        case .calm:
            return "This could be a nice moment for reflection or gratitude."
        case .good:
            return "You could use this energy for a positive reflection or gentle self-care activity."
        }
    }
    
    //  adds a reflective question depending on the mood
    var reflectionPrompt: String {
        switch currentMood {
        case .sad:
            return "What is one kind thing you need from yourself today?"
        case .anxious:
            return "What is one small thing you can control right now?"
        case .angry:
            return "What triggered this feeling, and what would help you to respond more calmly?"
        case .okay:
            return "What would help you feel a little better today?"
        case .calm:
            return "What is helping you feel steady today?"
        case .good:
            return "What is one positive thing you want to carry forward today?"
        }
    }
    
    var sliderColor: Color {
        switch currentMood {
        case .sad:
            return .blue
        case .anxious:
            return .orange
        case .angry:
            return .red
        case .okay:
            return .gray
        case .calm:
            return .green
        case .good:
            return .purple
        }
    }
    
    //  save button color based on the selected mood
    var saveButtonColor: Color {
        switch currentMood {
        case .sad:
            return Color(red: 0.42, green: 0.57, blue: 0.85)
        case .anxious:
            return Color(red: 0.88, green: 0.61, blue: 0.34)
        case .angry:
            return Color(red: 0.85, green: 0.38, blue: 0.38)
        case .okay:
            return Color(red: 0.56, green: 0.61, blue: 0.68)
        case .calm:
            return Color(red: 0.39, green: 0.71, blue: 0.57)
        case .good:
            return Color(red: 0.58, green: 0.47, blue: 0.85)
        }
    }
}
