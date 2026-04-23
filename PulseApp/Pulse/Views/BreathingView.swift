//
//  BreathingView.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 04/02/2026.

import SwiftUI

struct BreathingView: View {
    
    //  receives the users mood from HomeView
    var mood: UserMood?
    
    @State private var isExpanded = false
    
    @State private var phaseText = "Tap Start"

    @State private var showInstructions = false

    @State private var isRunning = false  // check if the breathing exercise is currently running
    
    //  to cancel old breathing loops when stopping or restarting
    @State private var sessionID = UUID()
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.12)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 24) {
                
                Spacer()
                
                // Title of the breathing exercise
                Text(breathingTitle)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                // Breathing pattern
                Text(breathingPattern)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                // Short explanation of the exercise
                Text(breathingDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Animated breathing circle
                Circle()
                    .fill(Color.white.opacity(0.88))
                    .frame(width: 190, height: 190)
                    .scaleEffect(isExpanded ? 1.2 : 0.75) // bigger on inhale, smaller on exhale
                    .animation(.easeInOut(duration: currentAnimationTime), value: isExpanded)
                    .overlay(
                        VStack(spacing: 6) {
                            Image(systemName: breathingIcon)
                                .font(.system(size: 32))
                                .foregroundColor(.blue)
                            
                            Text(phaseText)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.primary)
                        }
                    )
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                
                // Start / stop button
                Button {
                    if isRunning {
                        stopBreathing()
                    } else {
                        startBreathing()
                    }
                } label: {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 48)
                        .background(isRunning ? Color.red : Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                
                // instructions only appear after the user starts
                if showInstructions {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instruction")
                            .font(.headline)
                        
                        Text(currentInstruction)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Breathing")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //Start Breathing
    //starts the breathing loop
    func startBreathing() {
        let newSession = UUID()  // creates a new session so old loops stop
        sessionID = newSession
        isRunning = true
        showInstructions = true
        runCycle(session: newSession)
    }
    
    // Stop Breathing
    // stops the breathing loop and resets the UI
    func stopBreathing() {
        isRunning = false
        sessionID = UUID()    // cancels old loop
        phaseText = "Tap Start"
        isExpanded = false
    }
    
    // Run Cycle
    // inhale, hold, exhale
    func runCycle(session: UUID) {
        guard session == sessionID, isRunning else { return }
        
        // Inhale
        phaseText = "Inhale"
        isExpanded = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + inhaleTime) {
            guard session == sessionID, isRunning else { return }
            
            //  hold after inhale
            if holdAfterInhale > 0 {
                phaseText = "Hold"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + holdAfterInhale) {
                    guard session == sessionID, isRunning else { return }
                    startExhale(session: session)
                }
            } else {
                startExhale(session: session)
            }
        }
    }
    
    // Start Exhale
    func startExhale(session: UUID) {
        guard session == sessionID, isRunning else { return }
        
        // Exhale
        phaseText = "Exhale"
        isExpanded = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + exhaleTime) {
            guard session == sessionID, isRunning else { return }
            
            // boxox breathing has a second hold after exhale
            if holdAfterExhale > 0 {
                phaseText = "Hold"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + holdAfterExhale) {
                    guard session == sessionID, isRunning else { return }
                    runCycle(session: session)
                }
            } else {
                runCycle(session: session)
            }
        }
    }
    
    // Timing
    // control the timing of exercises
    
    var inhaleTime: Double {
        switch mood {
        case .anxious:
            return 4
        case .angry:
            return 4
        case .sad:
            return 4
        case .okay, .calm:
            return 4
        case .good:
            return 4
        case nil:
            return 4
        }
    }
    
    var holdAfterInhale: Double {
        switch mood {
        case .anxious:
            return 7
        case .good:
            return 4
        default:
            return 0
        }
    }
    
    var exhaleTime: Double {
        switch mood {
        case .anxious:
            return 8
        case .angry:
            return 6
        case .sad:
            return 5
        case .okay, .calm:
            return 4
        case .good:
            return 4
        case nil:
            return 4
        }
    }
    
    var holdAfterExhale: Double {
        switch mood {
        case .good:
            return 4
        default:
            return 0
        }
    }
    
    // to make circle animation match the current phase timing
    var currentAnimationTime: Double {
        if phaseText == "Exhale" {
            return exhaleTime
        } else {
            return inhaleTime
        }
    }
    
    // Breathing Content change depending on the user's mood
    
    var breathingTitle: String {
        switch mood {
        case .anxious:
            return "4-7-8 Breathing"
        case .angry:
            return "Extended Exhale Breathing"
        case .sad:
            return "Deep Breathing"
        case .okay, .calm:
            return "Gentle Breathing"
        case .good:
            return "Box Breathing"
        case nil:
            return "Simple Breathing"
        }
    }
    
    var breathingPattern: String {
        switch mood {
        case .anxious:
            return "Inhale 4 · Hold 7 · Exhale 8"
        case .angry:
            return "Inhale 4 · Exhale 6"
        case .sad:
            return "Inhale 4 · Exhale 5"
        case .okay, .calm:
            return "Inhale 4 . Exhale 4"
        case .good:
            return "Inhale 4 · Hold 4 · Exhale 4 · Hold 4"
        case nil:
            return "Inhale 4 · Exhale 4"
        }
    }
    
    var breathingDescription: String {
        switch mood {
        case .anxious:
            return "This technique may help slow anxious breathing and calm the body."
        case .angry:
            return "A longer exhale can help reduce tension and emotional intensity."
        case .sad:
            return "Deep breathing can feel grounding and gentle when emotions feel heavy."
        case .okay:
            return "Simple breathing rhythm helps you pause and reset."
        case .calm:
            return "Simple breathing rhythm helps you stay present and keep your calm."
        case .good:
            return "Box breathing can help you stay focused and steady."
        case nil:
            return "Take a quiet moment and breathe gently."
        }
    }
    
    // change the instruction text depending on the phase
    var currentInstruction: String {
        switch phaseText {
        case "Inhale":
            return "Breathe in slowly and steadily."
        case "Hold":
            return "Hold gently without straining."
        case "Exhale":
            return "Breathe out slowly and relax your body."
        default:
            return "Press Start when you are ready."
        }
    }
    
    //  different icons for diff breathing type
    var breathingIcon: String {
        switch mood {
        case .anxious, .sad:
            return "lungs.fill"
        case .angry:
            return "wind"
        case .okay, .calm:
            return "leaf.fill"
        case .good:
            return "square.grid.2x2.fill"
        case nil:
            return "lungs.fill"
        }
    }
}


#Preview {
    NavigationStack {
        BreathingView(mood: .anxious)
    }
}
