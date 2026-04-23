//
//  ContentView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 02/02/2026.


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var lastMood: UserMood? = nil

    var body: some View {
        TabView {
            NavigationStack {
                HomeView(lastMood: $lastMood)
            }
            .tabItem { Label("Home", systemImage: "house") }

            NavigationStack {
                InsightsView(lastMood: $lastMood)
            }
            .tabItem { Label("Insights", systemImage: "chart.bar") }

            NavigationStack {
                JournalView(mood: lastMood)
            }
            .tabItem { Label("Journal", systemImage: "square.and.pencil") }

            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("Profile", systemImage: "person") }
        }
        .onAppear {
            fetchLastSavedMood()
        }
    }
    
    func fetchLastSavedMood() {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("moodEntries")
            .whereField("userId", isEqualTo: user.uid)
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                
                if error != nil {
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    return
                }
                
                let data = document.data()
                let moodString = ((data["mood"] as? String) ?? "").lowercased()
                
                Task { @MainActor in
                    if moodString == "sad" {
                        lastMood = .sad
                    } else if moodString == "anxious" {
                        lastMood = .anxious
                    } else if moodString == "angry" {
                        lastMood = .angry
                    } else if moodString == "okay" {
                        lastMood = .okay
                    } else if moodString == "calm" {
                        lastMood = .calm
                    } else if moodString == "good" {
                        lastMood = .good
                    } else {
                        lastMood = nil
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
