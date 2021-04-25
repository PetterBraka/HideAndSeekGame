//
//  GameSceneVC.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 02/03/2021.
//

import UIKit
import SpriteKit

class GameSceneVC: UIViewController {
    var gameDifficulty: ChallangeRating?
    var numberOfBots: Int?
    var player: Player?
    var duration: Int?
    
    @IBAction func exitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? SKView? {
            // Checks if all the data needed to start a game is there.
            if gameDifficulty != nil && numberOfBots != nil && duration != nil {
                let scene = GameScene(size: self.view.bounds.size,
                                      difficulty: gameDifficulty!,
                                      player: player!,
                                      duration: duration!,
                                      numberOfBots: numberOfBots!)
                print("creating scene with user set values")
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            } else {
                let scene = GameScene(size: self.view.bounds.size,
                                      difficulty: .easy,
                                      player: Player(reach: .short, role: .hider, movmentSpeed: .normal),
                                      duration: 1,
                                      numberOfBots: 1)
                print("creating scene with preset values")
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            }
            view?.ignoresSiblingOrder = true
        }
    }
}
