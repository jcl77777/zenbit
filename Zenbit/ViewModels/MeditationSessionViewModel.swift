import CoreData
import Foundation
import SwiftUI

@MainActor
class MeditationSessionViewModel: ObservableObject {
    @Published var sessions: [MeditationSession] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        fetchSessions()
    }
    
    // MARK: - Fetch Sessions
    func fetchSessions() {
        isLoading = true
        errorMessage = nil
        
        let request: NSFetchRequest<MeditationSession> = MeditationSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MeditationSession.createdAt, ascending: false)]
        
        do {
            sessions = try coreDataManager.context.fetch(request)
        } catch {
            errorMessage = "無法載入冥想記錄: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Create Session
    func createSession(
        title: String = "冥想",
        duration: Int32 = 60,
        sessionType: String = "breathing",
        backgroundMusic: String = "rain",
        backgroundImage: String = "forest",
        moodBefore: Int16 = 3,
        moodAfter: Int16 = 3,
        notes: String? = nil
    ) {
        let session = MeditationSession(context: coreDataManager.context)
        session.id = UUID()
        session.title = title
        session.duration = duration
        session.sessionType = sessionType
        session.backgroundMusic = backgroundMusic
        session.backgroundImage = backgroundImage
        session.moodBefore = moodBefore
        session.moodAfter = moodAfter
        session.notes = notes
        session.startTime = Date()
        session.createdAt = Date()
        
        save()
        fetchSessions()
    }
    
    // MARK: - Update Session
    func updateSession(_ session: MeditationSession) {
        session.createdAt = Date()
        save()
        fetchSessions()
    }
    
    // MARK: - Delete Session
    func deleteSession(_ session: MeditationSession) {
        coreDataManager.context.delete(session)
        save()
        fetchSessions()
    }
    
    // MARK: - Save Context
    private func save() {
        coreDataManager.save()
    }
    
    // MARK: - Statistics
    var totalSessions: Int {
        sessions.count
    }
    
    var totalDuration: Int {
        sessions.reduce(0) { sum, session in sum + Int(session.duration) }
    }
    
    var averageMoodImprovement: Double {
        guard !sessions.isEmpty else { return 0 }
        let improvements = sessions.map { session in Double(session.moodAfter - session.moodBefore) }
        return improvements.reduce(0, +) / Double(improvements.count)
    }
    
    var sessionsThisWeek: Int {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return sessions.filter { session in
            guard let createdAt = session.createdAt else { return false }
            return createdAt >= oneWeekAgo
        }.count
    }
    
    var averageSessionDuration: Double {
        guard !sessions.isEmpty else { return 0 }
        let durations = sessions.map { session in Double(session.duration) }
        return durations.reduce(0, +) / Double(durations.count)
    }
} 