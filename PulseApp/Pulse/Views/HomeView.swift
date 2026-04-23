//
//  Homeview.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 02/02/2026.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("userName") private var userName: String = "User"
    
    //receives the user's last selected mood from ContentView
    @Binding var lastMood: UserMood?
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 18) {
                
                // Header
                ZStack(alignment: .leading) {
                    
                    LinearGradient(
                        colors: headerGradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(greetingText)
                            .foregroundColor(.white.opacity(0.9))
                            .font(.subheadline)
                        
                        Text(userName)
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                        
                        Text(Date.now.formatted(date: .complete, time: .omitted))
                            .foregroundColor(.white.opacity(0.85))
                            .font(.footnote)
                        
                        Text(calmMessage)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .padding(.top, 6)
                    }
                    .padding()
                }
                .frame(height: 155)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                
                //  Mood
                NavigationLink {
                    LogMoodView(lastMood: $lastMood)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How are you feeling today?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            if let mood = lastMood {
                                Text("\(mood.emoji) \(mood.rawValue)")
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Tap to log your mood")
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
                }
                .buttonStyle(.plain)
                
                // Today focus
                Text("Today’s Focus")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 8) {
                    if let mood = lastMood {
                        Text("Current mood: \(mood.emoji) \(mood.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                    } else {
                        Text("No mood recorded yet")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Text("Log your mood to get more personal suggestions and calming activities.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.95))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
                
                // Gentle reminder
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gentle Reminder")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(gentleReminderText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(reminderBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                
                // Recommendations
                Text("Recommended for you")
                    .font(.headline)
                
                NavigationLink {
                    BreathingView(mood: lastMood)
                } label: {
                    RecommendationCard(
                        title: recommendedExerciseTitle,
                        subtitle: recommendedExerciseSubtitle,
                        icon: recommendedExerciseIcon
                    )
                }
                .buttonStyle(.plain)
                
                NavigationLink {
                    MeditationView(mood: lastMood)
                } label: {
                    RecommendationCard(
                        title: recommendedMeditationTitle,
                        subtitle: recommendedMeditationSubtitle,
                        icon: recommendedMeditationIcon
                    )
                }
                .buttonStyle(.plain)
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(Color.gray.opacity(0.08))
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Greeting Text
    // it changes depending on the current time
    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour < 12 {
            return "Good morning,"
        } else if hour < 18 {
            return "Good afternoon,"
        } else {
            return "Good evening,"
        }
    }
    
    // Header
    // the header colors depending on mood
    var headerGradientColors: [Color] {
        guard let mood = lastMood else {
            return [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]
        }
        
        switch mood {
        case .sad:
            return [Color.blue.opacity(0.7), Color.cyan.opacity(0.5)]
        case .anxious:
            return [Color.orange.opacity(0.7), Color.yellow.opacity(0.5)]
        case .angry:
            return [Color.red.opacity(0.7), Color.orange.opacity(0.5)]
        case .okay:
            return [Color.gray.opacity(0.7), Color.blue.opacity(0.4)]
        case .calm:
            return [Color.green.opacity(0.7), Color.blue.opacity(0.5)]
        case .good:
            return [Color.purple.opacity(0.7), Color.blue.opacity(0.6)]
        }
    }
    
    //Header Message
    // the top supportive message depending on mood
    var calmMessage: String {
        guard let mood = lastMood else {
            return "Take a moment to check in with yourself."
        }
        
        switch mood {
        case .sad:
            return "Be gentle with yourself today."
        case .anxious:
            return "Breathe slowly. One small step at a time."
        case .angry:
            return "Pause first. Give yourself space before reacting."
        case .okay:
            return "You are doing alright. A small reset can still help."
        case .calm:
            return "A peaceful mind is a strong start to the day."
        case .good:
            return "Hold onto that good energy today."
        }
    }
    
    //  Recommended exercise title based on mood
    
    var recommendedExerciseTitle: String {
        guard let mood = lastMood else {
            return "Breathing Exercise"
        }
        
        switch mood {
        case .sad:
            return "Deep Breathing"
        case .anxious:
            return "4-7-8 Breathing"
        case .angry:
            return "Extended Exhale Breathing"
        case .okay:
            return "Natural Breathing"
        case .calm:
            return "Natural Breathing"
        case .good:
            return "Box Breathing"
        }
    }
    
    var recommendedMeditationTitle: String {
        guard let mood = lastMood else {
            return "Meditation"
        }
        
        switch mood {
        case .anxious:
            return "Body Scan Meditation"
        case .sad:
            return "Loving-Kindness Meditation"
        case .angry:
            return "Mindfulness Meditation"
        case .okay:
            return "Mindfulness Meditation"
        case .calm:
            return "Mindfulness Meditation"
        case .good:
            return "Loving-Kindness Meditation"
        }
    }


    //  meditation subtitle based on mood
    var recommendedMeditationSubtitle: String {
        guard let mood = lastMood else {
            return "Guided meditation · A quiet moment for yourself"
        }
        
        switch mood {
        case .anxious:
            return "Guided meditation · Body awareness and grounding"
        case .sad:
            return "Guided meditation · Self-kindness and warmth"
        case .angry:
            return "Guided meditation · Pause and observe emotion"
        case .okay:
            return "Guided meditation · Return to the present"
        case .calm:
            return "Guided meditation · Stay steady and aware"
        case .good:
            return "Guided meditation · Strengthen positive feelings"
        }
    }


    // meditation icon
    var recommendedMeditationIcon: String {
        guard let mood = lastMood else {
            return "figure.mind.and.body"
        }
        
        switch mood {
        case .anxious:
            return "figure.walk"
        case .sad:
            return "heart.fill"
        case .angry:
            return "eye"
        case .okay:
            return "leaf.fill"
        case .calm:
            return "figure.mind.and.body"
        case .good:
            return "sparkles"
        }
    }
   

    var recommendedExerciseSubtitle: String {
        guard let mood = lastMood else {
            return "Find your centre"
        }
        
        switch mood {
        case .sad:
            return "Gentle breathing"
        case .anxious:
            return "Slow your breathing"
        case .angry:
            return "Release tension"
        case .okay:
            return "Pause and reset"
        case .calm:
            return "Stay present and steady"
        case .good:
            return "Focus on positives"
        }
    }
    
    
    var recommendedExerciseIcon: String {
        guard let mood = lastMood else {
            return "lungs.fill"
        }
        
        switch mood {
        case .sad:
            return "lungs.fill"
        case .anxious:
            return "lungs.fill"
        case .angry:
            return "wind"
        case .okay:
            return "leaf.fill"
        case .calm:
            return "leaf.fill"
        case .good:
            return "sun.max.fill"
        }
    }
    
    //  Gentle reminder text
    var gentleReminderText: String {
        guard let mood = lastMood else {
            return "Small steps still count. Take one quiet moment for yourself today."
        }
        
        switch mood {
        case .sad:
            return "You do not need to do everything today. One kind step is enough."
        case .anxious:
            return "Slow down your breathing and come back to the present moment."
        case .angry:
            return "It is okay to step away and cool down before responding."
        case .okay:
            return "A small mindful break can make the rest of the day feel lighter."
        case .calm:
            return "Protect this peaceful feeling with one small act of self-care."
        case .good:
            return "Use this positive energy to support yourself in a gentle way."
        }
    }
    
    //  Reminder background color
    var reminderBackgroundColor: Color {
        guard let mood = lastMood else {
            return Color.blue.opacity(0.08)
        }
        
        switch mood {
        case .sad:
            return Color.blue.opacity(0.12)
        case .anxious:
            return Color.orange.opacity(0.12)
        case .angry:
            return Color.red.opacity(0.12)
        case .okay:
            return Color.gray.opacity(0.12)
        case .calm:
            return Color.green.opacity(0.12)
        case .good:
            return Color.purple.opacity(0.12)
        }
    }
}

// Exercise recommendation
struct RecommendationCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 42, height: 42)
                .background(Color.blue.opacity(0.08))
                .clipShape(Circle())
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.primary)
                    .font(.headline)
                
                Text(subtitle)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.96))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
    }
}
