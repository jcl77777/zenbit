import SwiftUI

struct ContentView: View {
    @State private var userSettings = UserSettings()
    
    var body: some View {
        Group {
            if userSettings.hasCompletedOnboarding {
                // 主 App
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("首頁")
                        }

                    ZenbitView()
                        .tabItem {
                            Image(systemName: "leaf.fill")
                            Text("冥想")
                        }

                    MeditationSessionPreviewView()
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("記錄")
                        }

                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("設定")
                        }
                }
            } else {
                // Onboarding 流程
                OnboardingView(hasCompletedOnboarding: $userSettings.hasCompletedOnboarding)
            }
        }
    }
}

#Preview {
    ContentView()
} 