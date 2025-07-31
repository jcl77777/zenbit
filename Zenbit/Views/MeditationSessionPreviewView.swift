import SwiftUI
import CoreData

struct MeditationSessionPreviewView: View {
    @StateObject private var viewModel = MeditationSessionViewModel()
    @State private var showingCreateSession = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("載入中...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        // Statistics Section
                        Section("統計") {
                            StatisticsRow(title: "總會話數", value: "\(viewModel.totalSessions)")
                            StatisticsRow(title: "總時長", value: "\(viewModel.totalDuration) 秒")
                            StatisticsRow(title: "平均時長", value: String(format: "%.1f 秒", viewModel.averageSessionDuration))
                            StatisticsRow(title: "本週會話", value: "\(viewModel.sessionsThisWeek)")
                            StatisticsRow(title: "心情改善", value: String(format: "%.1f", viewModel.averageMoodImprovement))
                        }
                        
                        // Sessions Section
                        Section("冥想記錄") {
                            if viewModel.sessions.isEmpty {
                                Text("尚無冥想記錄")
                                    .foregroundColor(.secondary)
                                    .italic()
                            } else {
                                ForEach(viewModel.sessions, id: \.id) { session in
                                    SessionRow(session: session) {
                                        viewModel.deleteSession(session)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("冥想記錄")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("新增") {
                        showingCreateSession = true
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("重新整理") {
                        viewModel.fetchSessions()
                    }
                }
            }
            .sheet(isPresented: $showingCreateSession) {
                CreateSessionView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchSessions()
            }
            .onReceive(NotificationCenter.default.publisher(for: .meditationSessionSaved)) { _ in
                // 當收到冥想記錄儲存通知時，刷新數據
                viewModel.fetchSessions()
            }
        }
    }
}

struct StatisticsRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
    }
}

struct SessionRow: View {
    let session: MeditationSession
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(session.title ?? "冥想")
                        .font(.headline)
                    
                    if let startTime = session.startTime {
                        Text(startTime, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(session.duration) 秒")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("心情: \(session.moodBefore) → \(session.moodAfter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if let notes = session.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            HStack {
                Text("音樂: \(session.backgroundMusic ?? "rain")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("圖片: \(session.backgroundImage ?? "forest")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            Button("刪除", role: .destructive) {
                onDelete()
            }
        }
    }
}

struct CreateSessionView: View {
    @ObservedObject var viewModel: MeditationSessionViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = "冥想"
    @State private var duration: Int32 = 60
    @State private var sessionType = "breathing"
    @State private var backgroundMusic = "rain"
    @State private var backgroundImage = "forest"
    @State private var moodBefore: Int16 = 3
    @State private var moodAfter: Int16 = 3
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本資訊") {
                    TextField("標題", text: $title)
                    
                    Stepper("時長: \(duration) 秒", value: $duration, in: 30...1800, step: 30)
                    
                    Picker("類型", selection: $sessionType) {
                        Text("呼吸冥想").tag("breathing")
                        Text("正念冥想").tag("mindfulness")
                        Text("身體掃描").tag("body_scan")
                    }
                }
                
                Section("背景設定") {
                    Picker("背景音樂", selection: $backgroundMusic) {
                        ForEach(BackgroundMusic.allCases, id: \.self) { music in
                            Text(music.displayName).tag(music.rawValue)
                        }
                    }
                    
                    Picker("背景圖片", selection: $backgroundImage) {
                        ForEach(BackgroundImage.allCases, id: \.self) { image in
                            Text(image.displayName).tag(image.rawValue)
                        }
                    }
                }
                
                Section("心情記錄") {
                    HStack {
                        Text("冥想前心情")
                        Spacer()
                        Stepper("\(moodBefore)", value: $moodBefore, in: 1...5)
                    }
                    
                    HStack {
                        Text("冥想後心情")
                        Spacer()
                        Stepper("\(moodAfter)", value: $moodAfter, in: 1...5)
                    }
                }
                
                Section("備註") {
                    TextField("備註", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("新增冥想")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("儲存") {
                        viewModel.createSession(
                            title: title,
                            duration: duration,
                            sessionType: sessionType,
                            backgroundMusic: backgroundMusic,
                            backgroundImage: backgroundImage,
                            moodBefore: moodBefore,
                            moodAfter: moodAfter,
                            notes: notes.isEmpty ? nil : notes
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MeditationSessionPreviewView()
} 