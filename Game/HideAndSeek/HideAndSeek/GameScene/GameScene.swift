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
    let joystickBackground = SKSpriteNode(imageNamed: "joystick_background")
    let joystick = SKSpriteNode(imageNamed: "joystick")
    let player = SKSpriteNode(imageNamed: "player")
    let playerMovePointsPerSec: CGFloat = 200
    
    var stickActive = false
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var velocity = CGPoint.zero
    
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
        spawnPlayer()
        createJoystick()
        spawnTent(newTent: true, CGPoint(x: size.width / 5, y: (size.height / 3) * 2))
    }
    
    fileprivate func createBackground() {
        let background = SKSpriteNode(imageNamed: "GameBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.aspectFillToSize(size: size)
        self.addChild(background)
    }
    
    fileprivate func spawnPlayer() {
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.zPosition = 1
        player.aspectFillToSize(size: CGSize(width: 25, height: 50))
        player.name = "player"
        self.addChild(player)
    }
    
    fileprivate func createJoystick() {
        joystickBackground.size = CGSize(width: 110, height: 110)
        joystickBackground.position = CGPoint(x: joystickBackground.size.width + 20, y: joystickBackground.size.height + 20)
        joystickBackground.alpha = 0.7
        joystickBackground.zPosition = 9
        self.addChild(joystickBackground)
        joystick.size = CGSize(width: joystickBackground.size.width / 2, height: joystickBackground.size.height / 2)
        joystick.position = joystickBackground.position
        joystick.zPosition = 10
        self.addChild(joystick)
    }
    
    fileprivate func spawnTent(newTent: Bool, _ position: CGPoint){
        var tent: SKSpriteNode
        if newTent {
            tent = SKSpriteNode(imageNamed: "tentNew")
        } else {
            tent = SKSpriteNode(imageNamed: "tentOld")
        }
        tent.aspectFillToSize(size: player.size)
        tent.name = "tent"
        tent.position = position
        tent.zPosition = 2
        self.addChild(tent)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if joystickBackground.contains(location) {
                stickActive = true
            } else {
                stickActive = false
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if stickActive {
                let v = CGVector(dx: location.x - joystickBackground.position.x, dy: location.y - joystickBackground.position.y)
                let angle: CGFloat = atan2(v.dy, v.dx)
                let length: CGFloat = joystickBackground.frame.size.height / 2
                let distance = CGPoint(x: sin(angle - 1.57079633) * length, y: cos(angle - 1.57079633) * length)
                if joystickBackground.frame.contains(location) {
                    joystick.position = location
                } else {
                    joystick.position = CGPoint(x: joystickBackground.position.x - distance.x, y: joystickBackground.position.y + distance.y)
                }
                moveTo(location)
                
                player.zRotation = angle - 1.57079633
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if stickActive {
            let move = SKAction.move(to: joystickBackground.position, duration: 0.2)
            joystick.run(move)
        }
        velocity = CGPoint.zero
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        move(player, velocity)
    }
    
    func moveTo(_ location: CGPoint){
        let offset = location - joystickBackground.position
        let direction = offset.normalized()
        velocity = direction * playerMovePointsPerSec
    }
    
    func move(_ sprite: SKSpriteNode, _ location: CGPoint){
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
}
