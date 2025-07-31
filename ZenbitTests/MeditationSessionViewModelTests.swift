import XCTest
import CoreData
@testable import Zenbit

class MeditationSessionViewModelTests: XCTestCase {
    var viewModel: MeditationSessionViewModel!
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        viewModel = MeditationSessionViewModel()
        
        // 清空測試資料
        coreDataManager.deleteAllSessions()
    }
    
    override func tearDown() {
        // 清空測試資料
        coreDataManager.deleteAllSessions()
        super.tearDown()
    }
    
    func testCreateSession() {
        // Given
        let initialCount = viewModel.sessions.count
        
        // When
        viewModel.createSession(
            title: "測試冥想",
            duration: 120,
            sessionType: "breathing",
            backgroundMusic: "rain",
            backgroundImage: "forest",
            moodBefore: 2,
            moodAfter: 4,
            notes: "測試備註"
        )
        
        // Then
        XCTAssertEqual(viewModel.sessions.count, initialCount + 1)
        
        let session = viewModel.sessions.first
        XCTAssertNotNil(session)
        XCTAssertEqual(session?.title, "測試冥想")
        XCTAssertEqual(session?.duration, 120)
        XCTAssertEqual(session?.sessionType, "breathing")
        XCTAssertEqual(session?.backgroundMusic, "rain")
        XCTAssertEqual(session?.backgroundImage, "forest")
        XCTAssertEqual(session?.moodBefore, 2)
        XCTAssertEqual(session?.moodAfter, 4)
        XCTAssertEqual(session?.notes, "測試備註")
        XCTAssertNotNil(session?.id)
        XCTAssertNotNil(session?.startTime)
        XCTAssertNotNil(session?.createdAt)
    }
    
    func testDeleteSession() {
        // Given
        viewModel.createSession(title: "要刪除的冥想")
        let initialCount = viewModel.sessions.count
        let sessionToDelete = viewModel.sessions.first!
        
        // When
        viewModel.deleteSession(sessionToDelete)
        
        // Then
        XCTAssertEqual(viewModel.sessions.count, initialCount - 1)
        XCTAssertFalse(viewModel.sessions.contains(sessionToDelete))
    }
    
    func testStatistics() {
        // Given
        viewModel.createSession(duration: 60, moodBefore: 2, moodAfter: 4)
        viewModel.createSession(duration: 120, moodBefore: 1, moodAfter: 3)
        viewModel.createSession(duration: 90, moodBefore: 3, moodAfter: 5)
        
        // When & Then
        XCTAssertEqual(viewModel.totalSessions, 3)
        XCTAssertEqual(viewModel.totalDuration, 270) // 60 + 120 + 90
        XCTAssertEqual(viewModel.averageSessionDuration, 90.0, accuracy: 0.1)
        XCTAssertEqual(viewModel.averageMoodImprovement, 2.0, accuracy: 0.1) // (2+2+2)/3
    }
    
    func testEmptyStatistics() {
        // When & Then
        XCTAssertEqual(viewModel.totalSessions, 0)
        XCTAssertEqual(viewModel.totalDuration, 0)
        XCTAssertEqual(viewModel.averageSessionDuration, 0.0)
        XCTAssertEqual(viewModel.averageMoodImprovement, 0.0)
        XCTAssertEqual(viewModel.sessionsThisWeek, 0)
    }
    
    func testFetchSessions() {
        // Given
        viewModel.createSession(title: "冥想1")
        viewModel.createSession(title: "冥想2")
        
        // When
        viewModel.fetchSessions()
        
        // Then
        XCTAssertEqual(viewModel.sessions.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
} 