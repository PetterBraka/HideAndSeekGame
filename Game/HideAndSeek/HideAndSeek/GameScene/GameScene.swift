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

enum Reach: Float {
    case short = 50
    case medium = 75
    case far = 100
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
    let playerRange = Reach.medium
    let buttonLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    var actionButton = SKSpriteNode(color: .red, size: CGSize(width: 100,height: 75))
    var tents: [SKSpriteNode] = []
    var stickActive: Bool = false
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var velocity: CGPoint = .zero
    var freezeJoystick: Bool = false
    
    init(size: CGSize,
         difficulty: ChallangeRating,
         player: Role,
         duration: Int,
         amountOfPlayers: Int) {
        gameDifficulty = difficulty
        playerRole = player
        playTime = duration
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
        createButton()
        spawnTent(newTent: true,
                  CGPoint(
                    x: size.width / 5,
                    y: (size.height / 3) * 2))
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
        joystickBackground.name = "joystick"
        joystickBackground.size = CGSize(width: 110, height: 110)
        joystickBackground.position = CGPoint(
            x: joystickBackground.size.width / 2 + 20,
            y: joystickBackground.size.height / 2 + 20)
        joystickBackground.alpha = 0.7
        joystickBackground.zPosition = 9
        self.addChild(joystickBackground)
        joystick.name = "joystick"
        joystick.size = CGSize(
            width: joystickBackground.size.width / 2,
            height: joystickBackground.size.height / 2)
        joystick.position = joystickBackground.position
        joystick.zPosition = 10
        self.addChild(joystick)
    }
    
    fileprivate func createButton() {
        actionButton = SKSpriteNode(imageNamed: "Button")
        actionButton.aspectFillToSize(size: CGSize(width: 100, height: 75))
        actionButton.name = "actionButton"
        actionButton.zPosition = 10
        actionButton.position = CGPoint(
            x: size.width - 50 - (actionButton.size.width / 2),
            y: 20 + actionButton.size.height / 2)
        self.addChild(actionButton)
        createButtonLable()
    }
    
    fileprivate func createButtonLable() {
        buttonLabel.text = "Action button"
        buttonLabel.name = "ButtonLabel"
        buttonLabel.color = .black
        buttonLabel.fontSize = 20
        buttonLabel.numberOfLines = 2
        buttonLabel.preferredMaxLayoutWidth = actionButton.size.width + 20
        buttonLabel.horizontalAlignmentMode = .center
        buttonLabel.verticalAlignmentMode = .top
        buttonLabel.position = CGPoint(
            x: actionButton.position.x,
            y: actionButton.position.y - actionButton.size.height / 2)
        buttonLabel.zPosition = 10
        self.addChild(buttonLabel)
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
        tents.append(tent)
        self.addChild(tent)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            switch self.atPoint(location).name {
            case joystickBackground.name:
                stickActive = true
            case actionButton.name:
                print("button taped")
                tents.forEach { (tent) in
                    if checkReachOf(player, to: tent) {
                        if !freezeJoystick{
                            let hidePlayer = SKAction.hide()
                            player.run(hidePlayer)
                            freezeJoystick = true
                            print("Player is hidden")
                            print("Freezing controlls")
                        } else {
                            let showPlayer = SKAction.unhide()
                            player.run(showPlayer)
                            freezeJoystick = false
                            print("Player isn't hidden")
                            print("Unfreezing controlls")
                        }
                    }
                }
            default:
                stickActive = false
            }
        }
    }
    
    fileprivate func checkReachOf(_ player: SKSpriteNode, to: SKSpriteNode) -> Bool {
        let distance = abs(hypotf(Float(player.position.x - to.position.x),
                                  Float(player.position.y - to.position.y)))
        if distance <= Float(playerRange.rawValue) {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func moveJoystick(_ location: CGPoint) {
        if !freezeJoystick {
            if stickActive {
                let radius = CGVector(dx: location.x - joystickBackground.position.x,
                                      dy: location.y - joystickBackground.position.y)
                let angle: CGFloat = atan2(radius.dy, radius.dx)
                let length: CGFloat = joystickBackground.frame.size.height / 2
                let distance = CGPoint(
                    x: sin(angle - 1.57079633) * length,
                    y: cos(angle - 1.57079633) * length)
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            moveJoystick(location)
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
        updateButtonLabel()
    }
    
    fileprivate func updateButtonLabel(){
            tents.forEach { (tent) in
                if checkReachOf(player, to: tent) {
                    if !freezeJoystick{
                        buttonLabel.text = "Hide"
                    } else {
                        buttonLabel.text = "Leave"
                    }
                } else {
                    buttonLabel.text = "Button"
                }
                actionButton.position = CGPoint(
                    x: size.width - 50 - (actionButton.size.width / 2),
                    y: 20 + actionButton.size.height / 2 + buttonLabel.frame.height)
                buttonLabel.position = CGPoint(
                    x: actionButton.position.x,
                    y: actionButton.position.y - actionButton.size.height / 2)
            }
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
