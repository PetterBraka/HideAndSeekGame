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
        createBackground()
        createPlayer()
        createJoystick()
    }
    
    fileprivate func createBackground() {
        let background = SKSpriteNode(imageNamed: "GameBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.aspectFillToSize(size: size)
        self.addChild(background)
    }
    
    fileprivate func createPlayer() {
        let player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.zPosition = 1
        player.aspectFillToSize(size: CGSize(width: 50, height: 75))
        self.addChild(player)
    }
    
    fileprivate func createJoystick() {
        let background = SKSpriteNode(imageNamed: "joystick_background")
        background.size = CGSize(width: 80, height: 80)
        background.position = CGPoint(x: background.size.width + 20, y: background.size.height + 20)
        background.zPosition = 0
        self.addChild(background)
        let joystick = SKSpriteNode(imageNamed: "joystick")
        joystick.size = CGSize(width: 40, height: 40)
        joystick.position = background.position
        joystick.zPosition = 1
        self.addChild(joystick)
    }
}
