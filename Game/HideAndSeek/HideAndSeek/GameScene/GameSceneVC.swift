//
//  GameSceneVC.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 02/03/2021.
//

import UIKit
import SpriteKit

class GameSceneVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: self.view.bounds.size, difficulty: .normal, player: .seeker, time: 10, amountOfPlayers: 2)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
