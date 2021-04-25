//
//  HelpTests.swift
//  HideAndSeekTests
//
//  Created by Petter vang Brakalsvålet on 25/04/2021.
//

import XCTest
@testable import HideAndSeek

class HelpTests: XCTestCase {
    var helpVC: HelpVC!
    
    var defaultHelpItems = [HelpVC.HelpItem(image: "Hider", explenation: "This is a hider. Your job as a hider is to hide from the seeker."),
                            HelpVC.HelpItem(image: "Seeker", explenation: "This is a seeker. Your job as a seeker is to catch all other players."),
                            HelpVC.HelpItem(image: "tentNew", explenation: "This is an hiding spot. You can hide here."),
                            HelpVC.HelpItem(image: "tentOld", explenation: "This is an hiding spot. You can hide here."),
                            HelpVC.HelpItem(image: "house", explenation: "This is an hiding spot. You can hide here."),
                            HelpVC.HelpItem(image: "joystick_background",secondImage: "joystick" , explenation: "This is an joystick. You can use this to move around on the map."),
                            HelpVC.HelpItem(image: "button", explenation: "This is the action button. I will have a label stating the action yo can preform.")]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        helpVC = HelpVC()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNumberOfHelpItems() {
        XCTAssertEqual(helpVC.helpItems.count, defaultHelpItems.count, "The number of help items is not as expected.")
    }
    
    func testHiderHelp() {
        if helpVC.helpItems[0].image == defaultHelpItems[0].image &&
            helpVC.helpItems[0].explenation == defaultHelpItems[0].explenation{
            XCTAssert(true)
        } else {
            XCTAssert(false,  "Hiders item is not as expected.")
        }
    }
    
    func testSeekerHelp() {
        if helpVC.helpItems[1].image == defaultHelpItems[1].image &&
            helpVC.helpItems[1].explenation == defaultHelpItems[1].explenation{
            XCTAssert(true)
        } else {
            XCTAssert(false,  "Seeker item is not as expected.")
        }
    }
    
    func testTentNewHelp() {
        if helpVC.helpItems[2].image == defaultHelpItems[2].image &&
            helpVC.helpItems[2].explenation == defaultHelpItems[2].explenation{
            XCTAssert(true)
        } else {
            XCTAssert(false,  "TentNew item is not as expected.")
        }
    }
    
    func testTentOldHelp() {
        if helpVC.helpItems[3].image == defaultHelpItems[3].image &&
            helpVC.helpItems[3].explenation == defaultHelpItems[3].explenation{
            XCTAssert(true)
        } else {
            XCTAssert(false,  "TentOld item is not as expected.")
        }
    }
    
    func testHouseHelp() {
        if helpVC.helpItems[4].image == defaultHelpItems[4].image &&
            helpVC.helpItems[4].explenation == defaultHelpItems[4].explenation{
            XCTAssert(true)
        } else {
            XCTAssert(false,  "House item is not as expected.")
        }
    }
    
    func testJoystickHelp() {
        if helpVC.helpItems[5].image == defaultHelpItems[5].image &&
            helpVC.helpItems[5].secondImage == defaultHelpItems[5].secondImage &&
            helpVC.helpItems[5].explenation == defaultHelpItems[5].explenation{
            XCTAssert(true)
        } else {
            XCTAssert(false,  "Joystick item is not as expected.")
        }
    }
    
    func testButtonHelp() {
        if helpVC.helpItems[6].image == defaultHelpItems[6].image &&
            helpVC.helpItems[6].explenation == defaultHelpItems[6].explenation{
            XCTAssert(true)
        } else {
            XCTAssert(false,  "Button item is not as expected.")
        }
    }
}
