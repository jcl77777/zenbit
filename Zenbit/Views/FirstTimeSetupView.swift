import SwiftUI

struct FirstTimeSetupView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var dailyGoal: Int = 1
    @State private var backgroundMusic: String = "rain"
    @State private var backgroundImage: String = "forest"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 標題
                VStack(spacing: 8) {
                    Text("個人化設定")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("讓我們為你量身打造冥想體驗")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // 設定選項
                VStack(spacing: 24) {
                    // 每日目標
                    VStack(alignment: .leading, spacing: 12) {
                        Text("每日冥想目標")
                            .font(.headline)
                        
                        HStack {
                            Text("每日冥想次數")
                            Spacer()
                            Text("\(dailyGoal) 次")
                                .foregroundColor(.blue)
                        }
                        
                        Stepper(value: $dailyGoal, in: 1...10) {
                            Text("目標：\(dailyGoal) 次")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // 背景音樂
                    VStack(alignment: .leading, spacing: 12) {
                        Text("背景音樂")
                            .font(.headline)
                        
                        Picker("背景音樂", selection: $backgroundMusic) {
                            ForEach(BackgroundMusic.allCases, id: \.self) { music in
                                Text(music.displayName)
                                    .tag(music.rawValue)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // 背景圖片
                    VStack(alignment: .leading, spacing: 12) {
                        Text("背景圖片")
                            .font(.headline)
                        
                        Picker("背景圖片", selection: $backgroundImage) {
                            ForEach(BackgroundImage.allCases, id: \.self) { image in
                                Text(image.displayName)
                                    .tag(image.rawValue)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Spacer()
                
                // 完成按鈕
                Button(action: {
                    saveSettings()
                    hasCompletedOnboarding = true
                }) {
                    Text("完成設定")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private func saveSettings() {
        let userSettings = UserSettings()
        userSettings.dailyGoal = dailyGoal
        userSettings.backgroundMusic = backgroundMusic
        userSettings.backgroundImage = backgroundImage
    }
}

#Preview {
    FirstTimeSetupView(hasCompletedOnboarding: .constant(false))
} 