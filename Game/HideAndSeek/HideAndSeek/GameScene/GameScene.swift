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
    var stickActive = false
    
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
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        player.zPosition = 1
        player.aspectFillToSize(size: CGSize(width: 50, height: 75))
        player.name = "player"
        self.addChild(player)
    }
    
    fileprivate func createJoystick() {
        joystickBackground.size = CGSize(width: 120, height: 120)
        joystickBackground.position = CGPoint(x: joystickBackground.size.width + 20, y: joystickBackground.size.height + 20)
        joystickBackground.alpha = 0.7
        joystickBackground.zPosition = 0
        self.addChild(joystickBackground)
        joystick.size = CGSize(width: 60, height: 60)
        joystick.position = joystickBackground.position
        joystick.zPosition = 1
        self.addChild(joystick)
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
                let angle = atan2(v.dy, v.dx)
                
                let degrees = angle * CGFloat( 180 / Double.pi)
                let length: CGFloat = joystickBackground.frame.size.height / 2
                
                let xDistance: CGFloat = sin(angle - 1.57079633) * length
                let yDistance: CGFloat = cos(angle - 1.57079633) * length
                
                if joystickBackground.frame.contains(location) {
                    joystick.position = location
                } else {
                    joystick.position = CGPoint(x: joystickBackground.position.x - xDistance, y: joystickBackground.position.y + yDistance)
                }
                player.zRotation = angle - 1.57079633
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if stickActive {
            let move = SKAction.move(to: joystickBackground.position, duration: 0.2)
            joystick.run(move)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
