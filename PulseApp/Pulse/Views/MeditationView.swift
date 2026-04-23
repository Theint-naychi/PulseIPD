//
//  MeditationView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 15/04/2026.
//
import SwiftUI

struct MeditationView: View {
    
    // receives users mood from HomeView
    var mood: UserMood?
    
    @State private var isRunning = false
    
    @State private var currentStepIndex = 0 //  stores which step is currently being shown
    
    @State private var sessionID = UUID()  // to stop old loops when the user press Stop
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.12), Color.purple.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    Spacer(minLength: 10)
                    
                    // Title of the meditation
                    Text(meditationTitle)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    // short subtitle
                    Text(meditationSubtitle)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    // description
                    Text(meditationDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer(minLength: 8)
                    
                    // main meditation card
                    VStack(spacing: 16) {
                        Image(systemName: meditationIcon)
                            .font(.system(size: 38))
                            .foregroundColor(.blue)
                        
                        Text(isRunning ? "Guidance" : "Ready to Begin")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(currentGuidanceText)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 10)
                            .frame(minHeight: 120)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .padding(.horizontal, 20)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
                    
                    // Start / stop button
                    Button {
                        if isRunning {
                            stopMeditation()
                        } else {
                            startMeditation()
                        }
                    } label: {
                        Text(isRunning ? "Stop" : "Start")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 140, height: 48)
                            .background(isRunning ? Color.red.opacity(0.85) : Color.blue.opacity(0.85))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    // Small note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gentle Note")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(meditationNote)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
        }
        .navigationTitle("Meditation")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // start meditation showing the guided steps one by one
    func startMeditation() {
        let newSession = UUID()
        sessionID = newSession
        isRunning = true
        currentStepIndex = 0
        runSteps(session: newSession)
    }
    
    // stop meditation and resets the guidance
    func stopMeditation() {
        isRunning = false
        sessionID = UUID()
        currentStepIndex = 0
    }
    
    // Run steps (stop at last step)
    func runSteps(session: UUID) {
        guard session == sessionID, isRunning else { return }
        
        // if already on the last step, stop
        if currentStepIndex >= meditationSteps.count - 1 {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            guard session == sessionID, isRunning else { return }
            
            // Move to the next step
            if currentStepIndex < meditationSteps.count - 1 {
                currentStepIndex += 1
                runSteps(session: session)
            }
        }
    }
    
    //  Current guidance text
    var currentGuidanceText: String {
        if isRunning {
            return meditationSteps[currentStepIndex]
        } else {
            return "Tap Start when you are ready."
        }
    }
    
    // Meditation title
    var meditationTitle: String {
        guard let mood = mood else {
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
    
    // Meditation subtitle
    var meditationSubtitle: String {
        guard let mood = mood else {
            return "A quiet moment for yourself"
        }
        
        switch mood {
        case .anxious:
            return "Ground yourself through body awareness"
        case .sad:
            return "Offer yourself kindness"
        case .angry:
            return "Pause and observe your emotions"
        case .okay:
            return "Return to the present moment"
        case .calm:
            return "Stay steady and aware"
        case .good:
            return "Strengthen warmth and positivity"
        }
    }
    
    // Meditation Description
    var meditationDescription: String {
        guard let mood = mood else {
            return "Take a few moments to reconnect with yourself."
        }
        
        switch mood {
        case .anxious:
            return "Body scan meditation can help ease anxious tension by bringing attention back to the body."
        case .sad:
            return "Loving-kindness meditation can support self-compassion and emotional comfort."
        case .angry:
            return "Mindfulness meditation can help you notice strong feelings without reacting immediately."
        case .okay:
            return "A light mindfulness practice can help you stay balanced and aware."
        case .calm:
            return "Sustained mindfulness can help you protect and deepen your calm state."
        case .good:
            return "Loving-kindness can help reinforce positive emotions and inner warmth."
        }
    }
    
    // Meditation steps
    var meditationSteps: [String] {
        guard let mood = mood else {
            return [
                "Take a moment to settle into a comfortable position.",
                "Notice how you feel right now,without trying to change anything.",
                "Allow yourself to pause and just be here.",
                "Stay with this quiet moment for a little while."
            ]
        }
        
        switch mood {
        case .anxious:
            return [
                "Take a moment to settle into a comfortable position. You may soften your gaze or gently close your eyes if that feels okay.",
                "Bring your attention to the top of your head, noticing any sensations.",
                "Let your awareness slowly move down through your shoulders, chest, and stomach.",
                "If you notice any tension, simply acknowledge it without trying to fix it.",
                "Let your awareness come to rest in your body. Stay here for a few moment. There is nothing else you need to do."
            ]
            
        case .sad:
            return [
                "Take a quiet moment for yourself, sitting comfortably.",
                "Notice how you’re feeling right now, without judging it.",
                "Silently say: May I be kind to myself.",
                "Silently say: May I feel safe and supported.",
                "Stay with that feeling of warmth for a few breaths."
            ]
            
        case .angry:
            return [
                "Sit still and notice the feeling present in you now.",
                "Name the feeling quietly: I am feeling anger.",
                "Notice where this feeling shows up in your body.",
                "Allow it to be there without acting on it.",
                "Let this feeling soften as you continue to observe it."
            ]
            
        case .okay:
            return [
                "Sit comfortably and notice your surroundings.",
                "Notice the sounds around you.",
                "Notice your thoughts as they come and go, without holding onto them.",
                "Bring your attention back to the present moment.",
                "Rest here for a few more seconds."
            ]
            
        case .calm:
            return [
                "Sit quietly and settle into this peaceful moment.",
                "Notice the present moment just as it is.",
                "Let your attention remain soft and steady.",
                "If your mind wanders, return gently to awareness.",
                "Stay here for a few moments. Let this sense of calm continue naturally."
            ]
            
        case .good:
            return [
                "Sit comfortably and think of something good in your life.",
                "Bring to mind something that feels good or meaningful today.",
                "Notice that feeling of warmth or positivity.",
                "Gently wish: May I continue to feel well. May others also feel peace and kindness.",
                "Rest in that positive feeling for a few breaths.Take it with you as you continue your day."
            ]
        }
    }
    
    // Meditation note
    var meditationNote: String {
        guard let mood = mood else {
            return "There is no need to do this perfectly. Just take one quiet moment at a time."
        }
        
        switch mood {
        case .anxious:
            return "If your mind feels busy, that is okay. Gently return attention to your body."
        case .sad:
            return "You do not need to force anything. Kindness can begin in small moments."
        case .angry:
            return "You are creating space between the feeling and the reaction."
        case .okay:
            return "A small mindful pause can still be valuable, even on ordinary days."
        case .calm:
            return "This is a good moment to stay present and hold onto your calm."
        case .good:
            return "Positive moments matter too. They can strengthen your overall wellbeing."
        }
    }
    
    //  icon
    var meditationIcon: String {
        guard let mood = mood else {
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
}

#Preview {
    NavigationStack {
        MeditationView(mood: .anxious)
    }
}
