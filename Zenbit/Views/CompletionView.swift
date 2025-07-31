import SwiftUI

struct CompletionView: View {
    let sessionDuration: Int
    let onDismiss: () -> Void
    
    @State private var moodBefore: Int16 = 3
    @State private var moodAfter: Int16 = 3
    @State private var notes = ""
    @State private var showAnimation = false
    @StateObject private var sessionViewModel = MeditationSessionViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 完成動畫
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                        .scaleEffect(showAnimation ? 1.2 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showAnimation)
                    
                    Text("冥想完成！")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("你完成了 \(sessionDuration / 60) 分鐘的冥想")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // 心情記錄
                VStack(spacing: 20) {
                    Text("心情記錄")
                        .font(.headline)
                    
                    HStack(spacing: 30) {
                        VStack(spacing: 10) {
                            Text("冥想前")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { index in
                                    Button(action: {
                                        moodBefore = Int16(index)
                                    }) {
                                        Image(systemName: index <= moodBefore ? "heart.fill" : "heart")
                                            .foregroundColor(index <= moodBefore ? .red : .gray)
                                    }
                                }
                            }
                        }
                        
                        VStack(spacing: 10) {
                            Text("冥想後")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { index in
                                    Button(action: {
                                        moodAfter = Int16(index)
                                    }) {
                                        Image(systemName: index <= moodAfter ? "heart.fill" : "heart")
                                            .foregroundColor(index <= moodAfter ? .red : .gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // 心得輸入
                VStack(alignment: .leading, spacing: 10) {
                    Text("心得（可選）")
                        .font(.headline)
                    
                    TextField("分享你的感受...", text: $notes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
                
                // 儲存按鈕
                Button(action: saveSession) {
                    Text("儲存記錄")
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
            .navigationTitle("完成")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("跳過") {
                        onDismiss()
                    }
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showAnimation = true
                }
            }
        }
    }
    
    private func saveSession() {
        // 儲存冥想記錄
        sessionViewModel.createSession(
            title: "冥想",
            duration: Int32(sessionDuration),
            sessionType: "breathing",
            backgroundMusic: "rain",
            backgroundImage: "forest",
            moodBefore: moodBefore,
            moodAfter: moodAfter,
            notes: notes.isEmpty ? nil : notes
        )
        
        // 發送通知讓其他視圖知道數據已更新
        NotificationCenter.default.post(name: .meditationSessionSaved, object: nil)
        
        onDismiss()
    }
}

// 定義通知名稱
extension Notification.Name {
    static let meditationSessionSaved = Notification.Name("meditationSessionSaved")
}

#Preview {
    CompletionView(sessionDuration: 60) {
        print("Dismissed")
    }
} 