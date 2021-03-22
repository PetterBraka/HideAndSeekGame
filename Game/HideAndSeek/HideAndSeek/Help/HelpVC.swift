//
//  HelpVC.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 15/03/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class HelpVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = Help(fileNamed: "HelpScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
