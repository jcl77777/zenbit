import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var duration: Int // 總秒數
    @Published var remaining: Int // 剩餘秒數
    @Published var isRunning = false
    @Published var isFinished = false
    
    private var timer: AnyCancellable?
    private var startDate: Date?
    private var pauseDate: Date?
    
    let minDuration = 60
    let maxDuration = 1800
    
    init(duration: Int = 60) {
        self.duration = duration
        self.remaining = duration
    }
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        isFinished = false
        startDate = Date()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func pause() {
        guard isRunning else { return }
        isRunning = false
        pauseDate = Date()
        timer?.cancel()
    }
    
    func reset() {
        isRunning = false
        isFinished = false
        timer?.cancel()
        remaining = duration
    }
    
    func setDuration(_ seconds: Int) {
        duration = max(minDuration, min(maxDuration, seconds))
        reset()
    }
    
    private func tick() {
        guard isRunning else { return }
        if remaining > 0 {
            remaining -= 1
        } else {
            isRunning = false
            isFinished = true
            timer?.cancel()
        }
    }
} 