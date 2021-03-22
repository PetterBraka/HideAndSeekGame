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
        getButtons()
    }
    
    func getButtons() {
        if let sign = self.childNode(withName: "sign") {
            print("found sign")
            playButton = sign.childNode(withName: "playButton") as? SKSpriteNode
            helpButton = sign.childNode(withName: "helpButton") as? SKSpriteNode
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        if let name = touchedNode.name {
            switch name {
            case playButton?.name:
                print("Play button pressed")
                let storyborad = UIStoryboard(name: "Main", bundle: nil)
                let setUpVC = storyborad.instantiateViewController(withIdentifier :"SetUpVC")
                let currentViewController:UIViewController = (UIApplication.shared.windows.first?.rootViewController!)!
                currentViewController.present(setUpVC, animated: true, completion: nil)
            case helpButton?.name:
                print("Help button pressed")
                let storyborad = UIStoryboard(name: "Main", bundle: nil)
                let helpVC = storyborad.instantiateViewController(withIdentifier :"HelpVC")
                let currentViewController:UIViewController = (UIApplication.shared.windows.first?.rootViewController!)!
                currentViewController.present(helpVC, animated: true, completion: nil)
            default:
                print("No button pressed")
            }
        }
    }
}
