//
//  MainMenuSceneTest.swift
//  HideAndSeekUITests
//
//  Created by Petter vang Brakalsvålet on 20/04/2021.
//

import XCTest
@testable import HideAndSeek

class MainMenuSceneTest: XCTestCase {
    
    var mainMenu: MainMenu!
    
    func testMainMenuSceneNumberOfChildren() {
        mainMenu = MainMenu()
        XCTAssert(mainMenu.scene?.children.count == 3)
    }

}
