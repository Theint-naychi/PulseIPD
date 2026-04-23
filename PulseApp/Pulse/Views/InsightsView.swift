//
//  InsightsView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 04/02/2026.

import SwiftUI
@preconcurrency import FirebaseAuth
@preconcurrency import FirebaseFirestore

struct InsightsView: View {
    
    @Binding var lastMood: UserMood?
    
    @State private var latestSavedMood: UserMood? = nil
    @State private var dayStreak: Int = 0
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var historyEntries: [HistoryEntry] = []
    
    struct HistoryEntry: Identifiable {
        let id = UUID()
        let date: Date
        let type: String
        let mood: String?
        let journalText: String?
    }
    
    var body: some View {
        
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    
                    // Header
                    ZStack(alignment: .leading) {
                        LinearGradient(
                            colors: headerGradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Insights")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("Your wellness journey")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                    }
                    .frame(height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
                    
                    HStack(spacing: 12) {
                        insightCard(
                            title: "Latest Mood",
                            value: currentMoodValue
                        )
                        
                        insightCard(
                            title: "Day Streak",
                            value: "\(dayStreak)"
                        )
                    }
                    
                    // History
                    VStack(alignment: .leading, spacing: 10) {
                        Text("History")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if historyEntries.isEmpty {
                            Text("No history yet.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        } else {
                            ForEach(historyEntries) { entry in
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    if entry.type == "mood" {
                                        Text("\(emojiForMood(entry.mood ?? "")) \(displayMoodText(entry.mood ?? ""))")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        
                                        Text("Mood logged")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    } else {
                                        Text("📝 Journal Entry")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        
                                        Text(entry.journalText ?? "No journal text")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .lineLimit(5)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
        }
        .navigationTitle("Insights")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchLatestMood()
            fetchDayStreak()
            fetchHistory()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // Latest mood text
    var currentMoodValue: String {
        if let mood = latestSavedMood {
            return "\(mood.emoji) \(mood.rawValue)"
        } else if let mood = lastMood {
            return "\(mood.emoji) \(mood.rawValue)"
        } else {
            return "No mood yet"
        }
    }
    
    // Header colours
    var headerGradientColors: [Color] {
        let moodToUse = latestSavedMood ?? lastMood
        
        if moodToUse == .sad {
            return [Color.blue.opacity(0.7), Color.cyan.opacity(0.5)]
        } else if moodToUse == .anxious {
            return [Color.orange.opacity(0.7), Color.yellow.opacity(0.5)]
        } else if moodToUse == .angry {
            return [Color.red.opacity(0.7), Color.orange.opacity(0.5)]
        } else if moodToUse == .okay {
            return [Color.gray.opacity(0.7), Color.blue.opacity(0.4)]
        } else if moodToUse == .calm {
            return [Color.green.opacity(0.7), Color.blue.opacity(0.5)]
        } else if moodToUse == .good {
            return [Color.purple.opacity(0.7), Color.blue.opacity(0.6)]
        } else {
            return [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]
        }
    }
    
    func fetchLatestMood() {
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No logged-in user was found."
            showError = true
            return
        }
        
        Firestore.firestore().collection("moodEntries")
            .whereField("userId", isEqualTo: user.uid)
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    Task { @MainActor in
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    return
                }
                
                let data = document.data()
                let moodString = ((data["mood"] as? String) ?? "").lowercased()
                
                Task { @MainActor in
                    if moodString == "sad" {
                        latestSavedMood = .sad
                    } else if moodString == "anxious" {
                        latestSavedMood = .anxious
                    } else if moodString == "angry" {
                        latestSavedMood = .angry
                    } else if moodString == "okay" {
                        latestSavedMood = .okay
                    } else if moodString == "calm" {
                        latestSavedMood = .calm
                    } else if moodString == "good" {
                        latestSavedMood = .good
                    } else {
                        latestSavedMood = nil
                    }
                }
            }
    }
    
    func fetchDayStreak() {
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No logged-in user was found."
            showError = true
            return
        }
        
        Firestore.firestore().collection("moodEntries")
            .whereField("userId", isEqualTo: user.uid)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    Task { @MainActor in
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    Task { @MainActor in
                        dayStreak = 0
                    }
                    return
                }
                
                let calendar = Calendar.current
                var moodDays: [Date] = []
                
                for document in documents {
                    let data = document.data()
                    
                    if let timestamp = data["date"] as? Timestamp {
                        let date = calendar.startOfDay(for: timestamp.dateValue())
                        
                        if !moodDays.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
                            moodDays.append(date)
                        }
                    }
                }
                
                if moodDays.isEmpty {
                    Task { @MainActor in
                        dayStreak = 0
                    }
                    return
                }
                
                var streak = 1
                
                for i in 1..<moodDays.count {
                    let previousDay = moodDays[i - 1]
                    let currentDay = moodDays[i]
                    
                    if let expectedDay = calendar.date(byAdding: .day, value: -1, to: previousDay),
                       calendar.isDate(currentDay, inSameDayAs: expectedDay) {
                        streak += 1
                    } else {
                        break
                    }
                }
                
                Task { @MainActor in
                    dayStreak = streak
                }
            }
    }
    
    func fetchHistory() {
        
        guard let user = Auth.auth().currentUser else { return }
        
        Firestore.firestore().collection("moodEntries")
            .whereField("userId", isEqualTo: user.uid)
            .order(by: "date", descending: true)
            .getDocuments { moodSnapshot, error in
                
                if let error = error {
                    Task { @MainActor in
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                    return
                }
                
                var moodEntries: [HistoryEntry] = []
                
                if let moodDocuments = moodSnapshot?.documents {
                    for doc in moodDocuments {
                        let data = doc.data()
                        
                        if let timestamp = data["date"] as? Timestamp,
                           let mood = data["mood"] as? String {
                            
                            moodEntries.append(
                                HistoryEntry(
                                    date: timestamp.dateValue(),
                                    type: "mood",
                                    mood: mood,
                                    journalText: nil
                                )
                            )
                        }
                    }
                }
                
                let savedMoodEntries = moodEntries
                
                Firestore.firestore().collection("journalEntries")
                    .whereField("userId", isEqualTo: user.uid)
                    .order(by: "date", descending: true)
                    .getDocuments { journalSnapshot, error in
                        
                        if let error = error {
                            Task { @MainActor in
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                            return
                        }
                        
                        var journalEntries: [HistoryEntry] = []
                        
                        if let journalDocuments = journalSnapshot?.documents {
                            for doc in journalDocuments {
                                let data = doc.data()
                                
                                if let timestamp = data["date"] as? Timestamp,
                                   let text = data["text"] as? String {
                                    
                                    journalEntries.append(
                                        HistoryEntry(
                                            date: timestamp.dateValue(),
                                            type: "journal",
                                            mood: nil,
                                            journalText: text
                                        )
                                    )
                                }
                            }
                        }
                        
                        let allEntries = savedMoodEntries + journalEntries
                        let sortedEntries = allEntries.sorted { $0.date > $1.date }
                        
                        Task { @MainActor in
                            historyEntries = sortedEntries
                        }
                    }
            }
    }
    
    func emojiForMood(_ mood: String) -> String {
        let moodText = mood.lowercased()
        
        if moodText == "sad" {
            return "😔"
        } else if moodText == "anxious" {
            return "😰"
        } else if moodText == "angry" {
            return "😠"
        } else if moodText == "okay" {
            return "😐"
        } else if moodText == "calm" {
            return "😌"
        } else if moodText == "good" {
            return "😊"
        } else {
            return "🙂"
        }
    }
    
    func displayMoodText(_ mood: String) -> String {
        let moodText = mood.lowercased()
        
        if moodText == "sad" {
            return "Sad"
        } else if moodText == "anxious" {
            return "Anxious"
        } else if moodText == "angry" {
            return "Angry"
        } else if moodText == "okay" {
            return "Okay"
        } else if moodText == "calm" {
            return "Calm"
        } else if moodText == "good" {
            return "Good"
        } else {
            return "Unknown mood"
        }
    }
    
    private func insightCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(value == "No mood yet" ? .subheadline : .title3)
                .bold()
                .foregroundColor(.primary)
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

#Preview {
    NavigationStack {
        InsightsView(lastMood: .constant(.calm))
    }
}
