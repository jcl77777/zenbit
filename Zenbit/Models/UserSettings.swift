import Foundation
import SwiftUI

struct UserSettings {
    @AppStorage("dailyGoal") var dailyGoal: Int = 1
    @AppStorage("backgroundMusic") var backgroundMusic: String = "rain"
    @AppStorage("backgroundImage") var backgroundImage: String = "forest"
    @AppStorage("healthKitAuthorized") var healthKitAuthorized: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
}

enum BackgroundMusic: String, CaseIterable {
    case rain = "rain"
    case forest = "forest"
    case ocean = "ocean"
    case silence = "silence"

    var displayName: String {
        switch self {
        case .rain: return "雨聲"
        case .forest: return "森林"
        case .ocean: return "海浪"
        case .silence: return "靜音"
        }
    }
}

enum BackgroundImage: String, CaseIterable {
    case forest = "forest"
    case mountain = "mountain"
    case ocean = "ocean"
    case sunset = "sunset"
    case minimal = "minimal"

    var displayName: String {
        switch self {
        case .forest: return "森林"
        case .mountain: return "山脈"
        case .ocean: return "海洋"
        case .sunset: return "日落"
        case .minimal: return "簡約"
        }
    }
} 