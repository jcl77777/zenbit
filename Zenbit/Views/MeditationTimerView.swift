import SwiftUI

struct MeditationTimerView: View {
    @StateObject private var timerVM = TimerViewModel()
    @State private var selectedDuration: Int = 60
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                timerDisplayView
                controlButtonsView
                durationSettingsView
                Spacer()
            }
            .padding()
            .navigationTitle("冥想計時器")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var timerDisplayView: some View {
        VStack(spacing: 20) {
            Text(timeString(from: timerVM.remaining))
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .animation(.easeInOut, value: timerVM.remaining)
            
            Text(timerVM.isRunning ? "冥想中..." : "準備開始")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
    
    private var controlButtonsView: some View {
        HStack(spacing: 30) {
            Button(action: toggleTimer) {
                Image(systemName: timerVM.isRunning ? "pause.fill" : "play.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(timerVM.isRunning ? Color.orange : Color.green)
                    .clipShape(Circle())
            }
            
            Button(action: resetTimer) {
                Image(systemName: "stop.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.red)
                    .clipShape(Circle())
            }
        }
    }
    
    private var durationSettingsView: some View {
        VStack(spacing: 15) {
            Text("設定時長")
                .font(.headline)
            
            Stepper(value: $selectedDuration, in: 30...600, step: 30) {
                Text("\(selectedDuration / 60) 分鐘")
                    .font(.title3)
            }
            .onChange(of: selectedDuration) { _, newValue in
                timerVM.setDuration(newValue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func toggleTimer() {
        if timerVM.isRunning {
            timerVM.pause()
        } else {
            timerVM.start()
        }
    }
    
    private func resetTimer() {
        timerVM.reset()
    }
    
    private func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    MeditationTimerView()
} 