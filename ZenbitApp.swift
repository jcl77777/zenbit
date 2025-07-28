import SwiftUI

// MARK: - User Settings Model
struct UserSettings {
    @AppStorage("dailyGoal") var dailyGoal: Int = 1
    @AppStorage("backgroundMusic") var backgroundMusic: String = "rain"
    @AppStorage("backgroundImage") var backgroundImage: String = "forest"
    @AppStorage("healthKitAuthorized") var healthKitAuthorized: Bool = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
}

// MARK: - Background Music Options
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

// MARK: - Background Image Options
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

// MARK: - Settings View
struct SettingsView: View {
    @State private var userSettings = UserSettings()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("每日目標")) {
                    HStack {
                        Text("每日冥想次數")
                        Spacer()
                        Text("\(userSettings.dailyGoal) 次")
                            .foregroundColor(.secondary)
                    }
                    
                    Stepper(value: $userSettings.dailyGoal, in: 1...10) {
                        Text("目標：\(userSettings.dailyGoal) 次")
                    }
                }
                
                Section(header: Text("背景音樂")) {
                    Picker("背景音樂", selection: $userSettings.backgroundMusic) {
                        ForEach(BackgroundMusic.allCases, id: \.self) { music in
                            Text(music.displayName)
                                .tag(music.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("背景圖片")) {
                    Picker("背景圖片", selection: $userSettings.backgroundImage) {
                        ForEach(BackgroundImage.allCases, id: \.self) { image in
                            Text(image.displayName)
                                .tag(image.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("設定")
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    @State private var userSettings = UserSettings()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Zenbit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Bit-Sized Calm for Busy Minds")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 10) {
                    Text("今日目標：\(userSettings.dailyGoal) 次")
                        .font(.headline)
                    
                    Text("背景音樂：\(BackgroundMusic(rawValue: userSettings.backgroundMusic)?.displayName ?? "未知")")
                        .font(.caption)
                    
                    Text("背景圖片：\(BackgroundImage(rawValue: userSettings.backgroundImage)?.displayName ?? "未知")")
                        .font(.caption)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Zenbit")
        }
    }
}

// MARK: - Main App
@main
struct ZenbitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首頁")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("設定")
                }
        }
    }
}

#Preview {
    ContentView()
}
