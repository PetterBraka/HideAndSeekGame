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
    var numberOfPlayers: Int?
    var player: Player?
    var duration: Int?
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? SKView? {
            // Load the SKScene from 'GameScene.sks'
            if gameDifficulty != nil && numberOfPlayers != nil && duration != nil {
                let scene = GameScene(size: self.view.bounds.size,
                                      difficulty: gameDifficulty!,
                                      player: player!,
                                      duration: duration!,
                                      amountOfPlayers: numberOfPlayers!)
                print("creating scene with user set values")
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            } else {
                let scene = GameScene(size: self.view.bounds.size, difficulty: .easy, player: Player(reach: .short, role: .hider, movmentSpeed: 200, image: "player"), duration: 1, amountOfPlayers: 1)
                print("creating scene with preset values")
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            }
            view?.ignoresSiblingOrder = true
            view?.showsFPS = true
            view?.showsNodeCount = true
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
