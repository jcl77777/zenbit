import SwiftUI

struct SettingsView: View {
    @State private var userSettings = UserSettings()
    @StateObject private var healthKitManager = HealthKitManager.shared
    @State private var showHealthKitAlert = false

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

                Section(header: Text("Apple Health")) {
                    HStack {
                        Text("HealthKit 授權")
                        Spacer()
                        if healthKitManager.isAuthorized || userSettings.healthKitAuthorized {
                            Label("已授權", systemImage: "checkmark.seal.fill")
                                .foregroundColor(.green)
                        } else {
                            Label("未授權", systemImage: "xmark.seal")
                                .foregroundColor(.red)
                        }
                    }
                    Button("重新請求授權") {
                        healthKitManager.requestAuthorization { success in
                            userSettings.healthKitAuthorized = success
                            showHealthKitAlert = true
                        }
                    }
                    .disabled(!healthKitManager.isHealthKitAvailable)
                }
            }
            .navigationTitle("設定")
            .onAppear {
                healthKitManager.checkAuthorizationStatus()
            }
            .alert(isPresented: $showHealthKitAlert) {
                Alert(
                    title: Text("HealthKit 授權"),
                    message: Text(healthKitManager.isAuthorized ? "授權成功！" : "授權失敗，請檢查系統設定。"),
                    dismissButton: .default(Text("確定"))
                )
            }
        }
    }
}

#Preview {
    SettingsView()
} 