//
//  JournalView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 02/02/2026.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct JournalView: View {
    
    var mood: UserMood?
    
    @State private var text: String = ""
    @State private var showSaved = false
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    // Word limit
    private let wordLimit = 300
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Date
                    Text(Date.now, style: .date)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 6)
                    
                    // Main title
                    Text("Journal")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                    
                    //  calming intro
                    Text("Take a quiet moment for yourself.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Prompt
                    Text(journalPrompt)
                        .font(.body)
                        .foregroundColor(.primary.opacity(0.82))
                        .padding(.top, 4)
                        .padding(.bottom, 6)
                    
                    // Writing area
                    ZStack(alignment: .topLeading) {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.90))
                        
                        if text.isEmpty {
                            Text("Start writing here...")
                                .foregroundColor(.gray.opacity(0.65))
                                .padding(.top, 18)
                                .padding(.leading, 18)
                        }
                        
                        TextEditor(text: $text)
                            .frame(minHeight: 260)
                            .padding(10)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .onChange(of: text) { _, newValue in
                                let trimmed = limitToWordCount(newValue, limit: wordLimit)
                                if trimmed != newValue {
                                    text = trimmed
                                }
                            }
                    }
                    .frame(minHeight: 260)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.purple.opacity(0.10), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.03), radius: 5, y: 2)
                    
                    // Word count
                    Text("\(wordCount(text)) / \(wordLimit) words")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    // Save button
                    Button {
                        saveJournalToFirestore()
                    } label: {
                        Text("Save Entry")
                            .font(.headline)
                            .foregroundColor(.blue.opacity(0.85))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.14), Color.purple.opacity(0.14)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.blue.opacity(0.12), lineWidth: 1)
                            )
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .padding(.top, 4)
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
        }
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Saved!", isPresented: $showSaved) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your journal entry was saved.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    //   journal prompt
    var journalPrompt: String {
        guard let mood = mood else {
            return "What is on your mind right now?"
        }
        
        switch mood {
        case .sad:
            return "What feels heavy today, and what do you need right now?"
        case .anxious:
            return "What is making you feel anxious, and what feels within your control?"
        case .angry:
            return "What triggered this feeling, and how would you like to respond?"
        case .okay:
            return "How has your day been so far?"
        case .calm:
            return "What is helping you feel peaceful at this moment?"
        case .good:
            return "What went well today that you want to remember?"
        }
    }
    
    // count the number of words in the text
    func wordCount(_ text: String) -> Int {
        let words = text.split { $0.isWhitespace || $0.isNewline }
        return words.count
    }
    
    // limit the text to the max number of words
    func limitToWordCount(_ text: String, limit: Int) -> String {
        let words = text.split { $0.isWhitespace || $0.isNewline }
        
        if words.count <= limit {
            return text
        } else {
            return words.prefix(limit).joined(separator: " ")
        }
    }
    
    func saveJournalToFirestore() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not logged in."
            showError = true
            return
        }
        
        let db = Firestore.firestore()
        
        let journalData: [String: Any] = [
            "userId": user.uid,
            "text": text,
            "mood": mood?.rawValue ?? "",
            "date": Timestamp(date: Date())
        ]
        
        db.collection("journalEntries").addDocument(data: journalData) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                showSaved = true
                text = ""
            }
        }
    }
}

#Preview {
    NavigationStack {
        JournalView()
    }
}
