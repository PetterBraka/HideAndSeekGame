//
//  MainMenuTests.swift
//  HideAndSeekTests
//
//  Created by Petter vang Brakalsvålet on 20/04/2021.
//

import XCTest
@testable import HideAndSeek

class MainMenuTests: XCTestCase {
    var mainMenu: MainMenu!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainMenu = MainMenu(fileNamed: "MainMenuScene")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPlayButton(){
        // This tests if the play button has been found in the scene.
        let playButton = mainMenu.playButton
        XCTAssert(playButton != nil, "Play button was not found")
    }
    
    func testHelpButton(){
        // This tests if the help button has been found in the scene.
        let helpButton = mainMenu.helpButton
        XCTAssert(helpButton != nil, "Help button was not found")
    }
    
    func testNumberOfChildrenInScene() {
        // This tests if the scene has the expected amount of children. 
        let children = mainMenu.children
        XCTAssert(children.count == 2, "Number of children in main menu is not what's expected")
    }
}
