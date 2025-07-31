import SwiftUI

struct HomeView: View {
    @State private var userSettings = UserSettings()
    @StateObject private var sessionViewModel = MeditationSessionViewModel()
    
    var todaySessions: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return sessionViewModel.sessions.filter { session in
            guard let createdAt = session.createdAt else { return false }
            return calendar.isDate(createdAt, inSameDayAs: today)
        }.count
    }
    
    var progressPercentage: Double {
        guard userSettings.dailyGoal > 0 else { return 0 }
        return min(Double(todaySessions) / Double(userSettings.dailyGoal), 1.0)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Zenbit")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Bit-Sized Calm for Busy Minds")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // 今日進度區塊
                VStack(spacing: 16) {
                    HStack {
                        Text("今日進度")
                            .font(.headline)
                        Spacer()
                        Text("\(todaySessions)/\(userSettings.dailyGoal)")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    
                    // 進度條
                    ProgressView(value: progressPercentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(y: 2)
                    
                    if todaySessions >= userSettings.dailyGoal {
                        Label("目標達成！", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    } else {
                        Text("還需要 \(userSettings.dailyGoal - todaySessions) 次冥想")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)

                // 當前設定區塊
                VStack(spacing: 10) {
                    Text("當前設定")
                        .font(.headline)
                        .padding(.top)
                    
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
            .onAppear {
                sessionViewModel.fetchSessions()
            }
            .onReceive(NotificationCenter.default.publisher(for: .meditationSessionSaved)) { _ in
                // 當收到冥想記錄儲存通知時，刷新數據
                sessionViewModel.fetchSessions()
            }
        }
    }
}

#Preview {
    HomeView()
} 