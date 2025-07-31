import SwiftUI
import AVFoundation

struct ZenbitView: View {
    @StateObject private var timerVM = TimerViewModel()
    @State private var userSettings = UserSettings()
    @State private var selectedDuration: Int = 60
    @State private var isSessionActive = false
    @State private var showCompletionView = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isAudioPlaying = false
    @State private var showCustomTimePicker = false
    @State private var customMinutes: Int = 1
    
    private let presetDurations = [1, 2, 3, 5] // 1, 2, 3, 5 分鐘
    
    var body: some View {
        ZStack {
            // 背景圖片
            backgroundImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .overlay(backgroundOverlay)
            
            VStack(spacing: 40) {
                Spacer()
                
                if !isSessionActive {
                    preparationView
                } else {
                    meditationView
                }
                
                Spacer()
            }
        }
        .navigationTitle("Zenbit")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupAudio()
        }
        .onDisappear {
            stopAudio()
        }
        .fullScreenCover(isPresented: $showCompletionView) {
            CompletionView(sessionDuration: selectedDuration) {
                showCompletionView = false
            }
        }
        .onChange(of: timerVM.isFinished) { _, finished in
            if finished {
                stopAudio()
                showCompletionView = true
            }
        }
        .sheet(isPresented: $showCustomTimePicker) {
            customTimePickerView
        }
    }
    
    private var backgroundImage: Image {
        switch userSettings.backgroundImage {
        case "forest":
            return Image(systemName: "leaf.fill")
        case "mountain":
            return Image(systemName: "mountain.2.fill")
        case "ocean":
            return Image(systemName: "water.waves")
        case "sunset":
            return Image(systemName: "sun.max.fill")
        case "minimal":
            return Image(systemName: "circle.fill")
        default:
            return Image(systemName: "leaf.fill")
        }
    }
    
    private var backgroundOverlay: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var preparationView: some View {
        VStack(spacing: 20) {
            Text("選擇冥想時長")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // 預設時間選擇器
            VStack(spacing: 10) {
                // 第一行：1分鐘和2分鐘
                HStack(spacing: 10) {
                    durationButton(for: 1 * 60, title: "1分鐘")
                    .frame(maxWidth: 150)
                    durationButton(for: 2 * 60, title: "2分鐘")
                    .frame(maxWidth: 150)
                }
                
                // 第二行：3分鐘和5分鐘
                HStack(spacing: 10) {
                    durationButton(for: 3 * 60, title: "3分鐘")
                    .frame(maxWidth: 150)
                    durationButton(for: 5 * 60, title: "5分鐘")
                    .frame(maxWidth: 150)
                }
                
                // 第三行：自定義時間
                durationButton(for: -1, title: "自定義時間")
                    .frame(maxWidth: 150)
            }
            .padding(.horizontal, 40)
            
            // 開始按鈕
            Button(action: startSession) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("開始冥想")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .frame(maxWidth: 150)
                .background(Color.green)
                .cornerRadius(8)
            }
            .padding(.horizontal, 60)
        }
        .padding()
    }
    
    private var customTimePickerView: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("自定義時間")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    Text("選擇分鐘數")
                        .font(.headline)
                    
                    Stepper(value: $customMinutes, in: 1...60) {
                        Text("\(customMinutes) 分鐘")
                            .font(.title3)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Spacer()
                
                Button(action: {
                    selectedDuration = customMinutes * 60
                    timerVM.setDuration(selectedDuration)
                    showCustomTimePicker = false
                }) {
                    Text("確認")
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
            .navigationTitle("自定義時間")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("取消") {
                        showCustomTimePicker = false
                    }
                }
            }
        }
    }
    
    private func durationButton(for duration: Int, title: String) -> some View {
        Button(action: {
            if duration == -1 {
                // 自定義時間
                showCustomTimePicker = true
            } else {
                selectedDuration = duration
                timerVM.setDuration(duration)
            }
        }) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(selectedDuration == duration ? .white : .white.opacity(0.9))
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedDuration == duration ? Color.green : Color.white.opacity(0.3))
                )
        }
    }
    
    private var meditationView: some View {
        VStack(spacing: 30) {
            Text(timeString(from: timerVM.remaining))
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .animation(.easeInOut, value: timerVM.remaining)
            
            HStack(spacing: 30) {
                Button(action: pauseSession) {
                    Image(systemName: timerVM.isRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Button(action: stopSession) {
                    Image(systemName: "stop.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }
    
    private func startSession() {
        isSessionActive = true
        timerVM.start()
        playBackgroundMusic()
    }
    
    private func pauseSession() {
        if timerVM.isRunning {
            timerVM.pause()
            pauseAudio()
        } else {
            timerVM.start()
            playBackgroundMusic()
        }
    }
    
    private func stopSession() {
        isSessionActive = false
        timerVM.reset()
        stopAudio()
    }
    
    private func setupAudio() {
        // 這裡可以載入背景音樂檔案
        // 目前使用系統音效作為示範
    }
    
    private func playBackgroundMusic() {
        isAudioPlaying = true
        // 播放背景音樂的邏輯
    }
    
    private func pauseAudio() {
        isAudioPlaying = false
        // 暫停背景音樂的邏輯
    }
    
    private func stopAudio() {
        isAudioPlaying = false
        // 停止背景音樂的邏輯
    }
    
    private func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    NavigationView {
        ZenbitView()
    }
} 