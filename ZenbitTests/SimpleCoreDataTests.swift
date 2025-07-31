import XCTest
import CoreData
@testable import Zenbit

class SimpleCoreDataTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
    }
    
    func testCoreDataManagerInitialization() {
        // Test that CoreDataManager can be initialized
        XCTAssertNotNil(coreDataManager)
        XCTAssertNotNil(coreDataManager.persistentContainer)
        XCTAssertNotNil(coreDataManager.context)
    }
    
    func testSaveContext() {
        // Test that context can be saved without errors
        XCTAssertNoThrow(coreDataManager.save())
    }
    
    func testCreateAndSaveSession() {
        // Test creating a session and saving it
        let session = MeditationSession(context: coreDataManager.context)
        session.id = UUID()
        session.title = "測試冥想"
        session.duration = 60
        session.sessionType = "breathing"
        session.backgroundMusic = "rain"
        session.backgroundImage = "forest"
        session.moodBefore = 3
        session.moodAfter = 4
        session.startTime = Date()
        session.createdAt = Date()
        
        // Save should not throw
        XCTAssertNoThrow(coreDataManager.save())
        
        // Verify the session was saved
        let request: NSFetchRequest<MeditationSession> = MeditationSession.fetchRequest()
        do {
            let sessions = try coreDataManager.context.fetch(request)
            XCTAssertEqual(sessions.count, 1)
            XCTAssertEqual(sessions.first?.title, "測試冥想")
        } catch {
            XCTFail("Failed to fetch sessions: \(error)")
        }
    }
} 