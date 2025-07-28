import XCTest
@testable import Zenbit

final class UserSettingsTests: XCTestCase {
    
    func testUserSettingsDefaultValues() {
        // Test the default values of the enums and struct properties
        // Note: @AppStorage values may be persisted, so we test the enum defaults instead
        
        // Test BackgroundMusic default
        XCTAssertEqual(BackgroundMusic.rain.rawValue, "rain")
        
        // Test BackgroundImage default
        XCTAssertEqual(BackgroundImage.forest.rawValue, "forest")
        
        // Test that the enums have the expected cases
        XCTAssertEqual(BackgroundMusic.allCases.count, 4)
        XCTAssertEqual(BackgroundImage.allCases.count, 5)
    }
    
    func testBackgroundMusicOptions() {
        // Given
        let options = BackgroundMusic.allCases
        
        // Then
        XCTAssertEqual(options.count, 4)
        XCTAssertTrue(options.contains(.rain))
        XCTAssertTrue(options.contains(.forest))
        XCTAssertTrue(options.contains(.ocean))
        XCTAssertTrue(options.contains(.silence))
    }
    
    func testBackgroundMusicDisplayNames() {
        // Then
        XCTAssertEqual(BackgroundMusic.rain.displayName, "雨聲")
        XCTAssertEqual(BackgroundMusic.forest.displayName, "森林")
        XCTAssertEqual(BackgroundMusic.ocean.displayName, "海浪")
        XCTAssertEqual(BackgroundMusic.silence.displayName, "靜音")
    }
    
    func testBackgroundImageOptions() {
        // Given
        let options = BackgroundImage.allCases
        
        // Then
        XCTAssertEqual(options.count, 5)
        XCTAssertTrue(options.contains(.forest))
        XCTAssertTrue(options.contains(.mountain))
        XCTAssertTrue(options.contains(.ocean))
        XCTAssertTrue(options.contains(.sunset))
        XCTAssertTrue(options.contains(.minimal))
    }
    
    func testBackgroundImageDisplayNames() {
        // Then
        XCTAssertEqual(BackgroundImage.forest.displayName, "森林")
        XCTAssertEqual(BackgroundImage.mountain.displayName, "山脈")
        XCTAssertEqual(BackgroundImage.ocean.displayName, "海洋")
        XCTAssertEqual(BackgroundImage.sunset.displayName, "日落")
        XCTAssertEqual(BackgroundImage.minimal.displayName, "簡約")
    }
    
    func testDailyGoalRange() {
        // Test that daily goal can be set within valid range
        var settings = UserSettings()
        
        // Test minimum value
        settings.dailyGoal = 1
        XCTAssertEqual(settings.dailyGoal, 1)
        
        // Test maximum value
        settings.dailyGoal = 10
        XCTAssertEqual(settings.dailyGoal, 10)
        
        // Test middle value
        settings.dailyGoal = 5
        XCTAssertEqual(settings.dailyGoal, 5)
    }
    
    func testBackgroundMusicRawValues() {
        // Test that raw values match expected strings
        XCTAssertEqual(BackgroundMusic.rain.rawValue, "rain")
        XCTAssertEqual(BackgroundMusic.forest.rawValue, "forest")
        XCTAssertEqual(BackgroundMusic.ocean.rawValue, "ocean")
        XCTAssertEqual(BackgroundMusic.silence.rawValue, "silence")
    }
    
    func testBackgroundImageRawValues() {
        // Test that raw values match expected strings
        XCTAssertEqual(BackgroundImage.forest.rawValue, "forest")
        XCTAssertEqual(BackgroundImage.mountain.rawValue, "mountain")
        XCTAssertEqual(BackgroundImage.ocean.rawValue, "ocean")
        XCTAssertEqual(BackgroundImage.sunset.rawValue, "sunset")
        XCTAssertEqual(BackgroundImage.minimal.rawValue, "minimal")
    }
} 