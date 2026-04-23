//
//  Mood.swift
//  Pulse
//
//  Created by Theint Nay Chi Naing Win on 04/02/2026.
//

import Foundation

enum UserMood: String, CaseIterable, Identifiable {
    case sad = "Sad"
    case anxious = "Anxious"
    case angry = "Angry"
    case okay = "Okay"
    case calm = "Calm"
    case good = "Good"
    

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .sad: return "😔"
        case .anxious: return "😟"
        case.angry: return "😠"
        case .okay: return "😐"
        case .calm: return "😌"
        case .good: return "😊"
        }
    }
}
