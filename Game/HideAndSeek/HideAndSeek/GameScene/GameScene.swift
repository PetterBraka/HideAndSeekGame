//
//  GameScene.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 26/02/2021.
//

import SpriteKit
import GameplayKit

enum ChallangeRating {
    case easy
    case normal
    case hard
}

enum Role {
    case hider
    case seeker
}

class GameScene: SKScene {
    let gameDifficulty: ChallangeRating
    let playerRole: Role
    let playTime: Int
    let numberOfPlayers: Int
    
    init(size: CGSize,
         difficulty: ChallangeRating,
         player: Role,
         time: Int,
         amountOfPlayers: Int) {
        gameDifficulty = difficulty
        playerRole = player
        playTime = time
        numberOfPlayers = amountOfPlayers
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        if let background = SKSpriteNode(fileNamed: "GameBackground") {
            
            background.position = CGPoint(x: size.width / 2, y: size.height / 2)
            background.aspectFillToSize(size: view.frame.size)
            addChild(background)
        }
    }
}
