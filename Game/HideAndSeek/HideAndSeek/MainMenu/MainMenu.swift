//
//  MainMenu.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 22/02/2021.
//

import UIKit
import SpriteKit

class MainMenu: SKScene {
    var playButton: SKSpriteNode?
    var helpButton: SKSpriteNode?
    
    override func sceneDidLoad() {
        // When the scene has been loaded it will look for a node named 'sign' and if found it will assign the play and help button.
        if let sign = self.childNode(withName: "sign") {
            #if DEBUG
            print("found sign")
            #endif
            playButton = sign.childNode(withName: "playButton") as? SKSpriteNode
            helpButton = sign.childNode(withName: "helpButton") as? SKSpriteNode
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        // Takes the first touch that was sent and gets the name from it.
        if let name = touchedNode.name {
            // Checks the name of the node pressed and if it equals to any of the buttons avalible.
            switch name {
            case playButton?.name:
                #if DEBUG
                print("Play button pressed")
                #endif
                // Creates an segua from MainMenu to SetUpVC
                let storyborad = UIStoryboard(name: "Main", bundle: nil)
                let setUpVC = storyborad.instantiateViewController(withIdentifier :"SetUpVC")
                let currentViewController:UIViewController = (UIApplication.shared.windows.first?.rootViewController!)!
                currentViewController.present(setUpVC, animated: true, completion: nil)
            case helpButton?.name:
                #if DEBUG
                print("Help button pressed")
                #endif
                // Creates an segua from MainMenu to HelpVC
                let storyborad = UIStoryboard(name: "Main", bundle: nil)
                let helpVC = storyborad.instantiateViewController(withIdentifier :"HelpVC")
                let currentViewController:UIViewController = (UIApplication.shared.windows.first?.rootViewController!)!
                currentViewController.present(helpVC, animated: true, completion: nil)
            default:
                #if DEBUG
                print("No button pressed")
                #endif
            }
        }
    }
}
