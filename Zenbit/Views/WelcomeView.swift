import SwiftUI

struct WelcomeView: View {
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // App Logo/Title
            VStack(spacing: 16) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("Zenbit")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Bit-Sized Calm for Busy Minds")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // App 介紹
            VStack(spacing: 20) {
                FeatureRow(icon: "timer", title: "1分鐘冥想", description: "忙碌生活中的快速平靜")
                FeatureRow(icon: "heart.fill", title: "心情追蹤", description: "記錄冥想前後的心情變化")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "進度統計", description: "查看你的冥想習慣和成就")
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // 開始按鈕
            Button(action: {
                hasCompletedOnboarding = true
            }) {
                Text("開始使用")
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
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    WelcomeView(hasCompletedOnboarding: .constant(false))
} 