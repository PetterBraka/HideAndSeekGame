//
//  SetUpTests.swift
//  HideAndSeekTests
//
//  Created by Petter vang Brakalsvålet on 20/04/2021.
//

import XCTest
@testable import HideAndSeek

class SetUpTests: XCTestCase {
    private struct GameOptions {
        var title: String
        var hasSegments: Bool
        var options: [String]?
    }
    var setUpVC: SetUpVC!
    private var defaultOptions = [
        GameOptions(title: "Role", hasSegments: true, options: [Player.Role.hider.rawValue, Player.Role.seeker.rawValue]),
        GameOptions(title: "Difficulty", hasSegments: true,
                    options: [ChallangeRating.easy.rawValue,
                              ChallangeRating.normal.rawValue,
                              ChallangeRating.hard.rawValue]),
        GameOptions(title: "Speed", hasSegments: true, options: ["Slow", "Normal", "Fast"]),
        GameOptions(title: "Reach", hasSegments: true, options: ["Short", "Medium", "Far"]),
        GameOptions(title: "Duration", hasSegments: false),
        GameOptions(title: "Bots", hasSegments: false)]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setUpVC = SetUpVC()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNumberOfSetUpOptions() {
        XCTAssert(setUpVC.gameOptions.count == defaultOptions.count, "Number of game options is not what's expected")
    }
    
    // Test position of game options
    func testPositionOfRoleOption(){
        let gameOptions = setUpVC.gameOptions
        let index = gameOptions.firstIndex(where: {$0.title == defaultOptions[0].title})
        XCTAssertEqual(index, 0, "Role option is not at expected index")
    }
    
    func testPositionOfDifficultyOption(){
        let gameOptions = setUpVC.gameOptions
        let index = gameOptions.firstIndex(where: {$0.title == defaultOptions[1].title})
        XCTAssertEqual(index, 1, "Difficulty option is not at expected index")
    }
    
    func testPositionOfSpeedOption(){
        let gameOptions = setUpVC.gameOptions
        let index = gameOptions.firstIndex(where: {$0.title == defaultOptions[2].title})
        XCTAssertEqual(index, 2, "Speed option is not at expected index")
    }
    
    func testPositionOfReachOption(){
        let gameOptions = setUpVC.gameOptions
        let index = gameOptions.firstIndex(where: {$0.title == defaultOptions[3].title})
        XCTAssertEqual(index, 3, "Reach option is not at expected index")
    }
    
    func testPositionOfDurationOption(){
        let gameOptions = setUpVC.gameOptions
        let index = gameOptions.firstIndex(where: {$0.title == defaultOptions[4].title})
        XCTAssertEqual(index, 4, "Duration option is not at expected index")
    }
    
    func testPositionOfBotsOption(){
        let gameOptions = setUpVC.gameOptions
        let index = gameOptions.firstIndex(where: {$0.title == defaultOptions[5].title})
        XCTAssertEqual(index, 5, "Bots option is not at expected index")
    }
    
    // Test number of segments of game options
    func testNumberOfSegmentsOfRoleOption(){
        let gameOptions = setUpVC.gameOptions
        XCTAssertEqual(gameOptions[0].segments, defaultOptions[0].options, "Number of segments of role option is not as expected")
    }
    
    func testNumberOfSegmentsOfDifficultyOption(){
        let gameOptions = setUpVC.gameOptions
        XCTAssertEqual(gameOptions[1].segments, defaultOptions[1].options, "Number of segments of difficulty option is not as expected")
    }
    
    func testNumberOfSegmentsOfSpeedOption(){
        let gameOptions = setUpVC.gameOptions
        XCTAssertEqual(gameOptions[2].segments, defaultOptions[2].options, "Number of segments of speed option is not as expected")
    }
    
    func testNumberOfSegmentsOfReachOption(){
        let gameOptions = setUpVC.gameOptions
        XCTAssertEqual(gameOptions[3].segments, defaultOptions[3].options, "Number of segments of reach option is not as expected")
    }
    
    func testNumberOfSegmentsOfDurationOption(){
        let gameOptions = setUpVC.gameOptions
        XCTAssertNil(gameOptions[4].segments, "Number of segments of duration option is not nil")
    }
    
    func testNumberOfSegmentsOfBotsOption(){
        let gameOptions = setUpVC.gameOptions
        XCTAssertNil(gameOptions[5].segments, "Number of segments of bots option is not nil")
    }
    
    func testRoleOption(){
        let gameOption = setUpVC.gameOptions[0]
        XCTAssert(
            gameOption.segments?[0] == defaultOptions[0].options?[0] &&
                gameOption.segments?[1] == defaultOptions[0].options?[1], "The role options isn't matching the expected options.")
    }
    
    func testDifficultyOption(){
        let gameOption = setUpVC.gameOptions[1]
        XCTAssert(
            gameOption.segments?[0] == defaultOptions[1].options?[0] &&
                gameOption.segments?[1] == defaultOptions[1].options?[1] &&
                gameOption.segments?[2] == defaultOptions[1].options?[2], "The difficulty options isn't matching the expected options.")
    }
    
    func testSpeedOption(){
        let gameOption = setUpVC.gameOptions[2]
        XCTAssert(
            gameOption.segments?[0] == defaultOptions[2].options?[0] &&
                gameOption.segments?[1] == defaultOptions[2].options?[1] &&
                gameOption.segments?[2] == defaultOptions[2].options?[2], "The speed options isn't matching the expected options.")
    }
    
    func testReachOption(){
        let gameOption = setUpVC.gameOptions[3]
        XCTAssert(
            gameOption.segments?[0] == defaultOptions[3].options?[0] &&
                gameOption.segments?[1] == defaultOptions[3].options?[1] &&
                gameOption.segments?[2] == defaultOptions[3].options?[2], "The reach options isn't matching the expected options.")
    }
}
