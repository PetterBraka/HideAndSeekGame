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

class GameScene: SKScene {
    let gameDifficulty: ChallangeRating
    let duration: Int
    let numberOfPlayers: Int
    let joystickBackground = SKSpriteNode(imageNamed: "joystick_background")
    let joystick = SKSpriteNode(imageNamed: "joystick")
    let mountain = SKSpriteNode(imageNamed: "mountain")
    let buttonLabel = SKLabelNode(fontNamed: "Chalkduster")
    let gameArea = CGSize(width: 1600, height: 800)
    let cameraNode = SKCameraNode()
    
    var playableArea: CGRect
    var player: Player
    var actionButton = SKSpriteNode(color: .red, size: CGSize(width: 100,height: 75))
    var hidingSpots: [HidingSpot] = []
    var stickActive: Bool = false
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var velocity: CGPoint = .zero
    var freezeJoystick: Bool = false
    
    init(size: CGSize, difficulty: ChallangeRating, duration: Int, amountOfPlayers: Int) {
        self.gameDifficulty = difficulty
        self.duration = duration
        self.numberOfPlayers = amountOfPlayers
        self.player = Player(reach: .medium, role: .seeker, movmentSpeed: 200, image: "player")
        self.playableArea = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
        super.init(size: size)
        self.playableArea = getPlayableArea()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getPlayableArea() -> CGRect{
        let aspectRatio = frame.width / frame.height
        let playableHeight = size.width / aspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        return CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
    }
    
    override func didMove(to view: SKView) {
        createMap()
        createJoystick()
        createButton()
        spawnPlayer()
        drawHouse()
        drawTents()
        drawCampfire()
        drawRiver()
        addCamera()
        debugDrawPlayableArea()
    }
    
    fileprivate func addCamera(){
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = player.spriteNode.position
    }
    
    fileprivate func createMap() {
        let background = SKSpriteNode(imageNamed: "gameBackground")
        background.position = CGPoint(x: gameArea.width / 2, y: gameArea.height / 2)
        background.zPosition = -1
        background.aspectFillToSize(size: gameArea)
        self.addChild(background)
        mountain.anchorPoint = CGPoint(x: 0, y: 1)
        mountain.position = CGPoint(x: 0, y: background.size.height)
        mountain.zPosition = 0
        mountain.size = CGSize(
            width: ((background.size.width / 8) * 2) + (background.size.width / 12),
            height: background.size.height - (background.size.height / 10))
        self.addChild(mountain)
    }
    
    func debugDrawPlayableArea() {
        let aspectRatio = frame.width / frame.height
        let playableHeight = playableArea.width / aspectRatio
        let playableMargin = (playableArea.height - playableHeight) / 2.0
        let shape = SKShapeNode(rect: CGRect(x: 0, y: playableMargin, width: size.width, height: playableArea.height))
        shape.strokeColor = .systemRed
        shape.lineWidth = 5
        shape.zPosition = 20
        shape.position = CGPoint(x: -playableArea.width / 2, y: playableMargin - playableArea.height / 2)
        cameraNode.addChild(shape)
    }
    
    fileprivate func drawHouse() {
        let house = HidingSpot(.house, CGPoint(x: gameArea.width / 8 * 4, y: gameArea.height / 16 * 13), image: "house", capacity: 2)
        self.addChild(house.spriteNode)
        hidingSpots.append(house)
        self.addChild(house.drawDebugArea())
    }
    
    fileprivate func drawTents(){
        spawnTent(newTent: true, CGPoint(x: (gameArea.width / 8),
                                         y: (gameArea.height / 4 * 3)))
        spawnTent(newTent: true, CGPoint(x: (gameArea.width / 16 * 3),
                                         y: (gameArea.height / 8 * 5) + 50))
        spawnTent(newTent: false, CGPoint(x: (gameArea.width / 16 * 5),
                                          y: (gameArea.height / 8 * 5)))
        spawnTent(newTent: false, CGPoint(x: (gameArea.width / 8 * 2),
                                          y: (gameArea.height / 4 * 2)))
    }
    
    fileprivate func drawCampfire(){
        let campfire = SKSpriteNode(imageNamed: "campfire")
        campfire.position = CGPoint(x: gameArea.width / 16 * 7, y: gameArea.height / 4 * 2)
        campfire.zPosition = 0
        campfire.aspectFillToSize(size: player.spriteNode.size)
        self.addChild(campfire)
    }
    
    fileprivate func drawRiver(){
        let river = SKSpriteNode(imageNamed: "river")
        river.position = CGPoint(x: gameArea.width / 16 * 11, y: gameArea.height / 2)
        river.zPosition = 0
        river.size = CGSize(width: gameArea.width / 8, height: gameArea.height)
        self.addChild(river)
    }
    
    fileprivate func createJoystick() {
        joystickBackground.name = "joystick"
        joystickBackground.size = CGSize(width: 110, height: 110)
        joystickBackground.position = CGPoint(
            x: (joystickBackground.size.width / 2 + 20) - playableArea.width / 2,
            y: (joystickBackground.size.height / 2 + 20) - playableArea.height / 2)
        joystickBackground.alpha = 0.7
        joystickBackground.zPosition = 9
        cameraNode.addChild(joystickBackground)
        joystick.name = "joystick"
        joystick.size = CGSize(
            width: joystickBackground.size.width / 2,
            height: joystickBackground.size.height / 2)
        joystick.position = joystickBackground.position
        joystick.zPosition = 10
        cameraNode.addChild(joystick)
    }
    
    fileprivate func createButton() {
        actionButton = SKSpriteNode(imageNamed: "button")
        actionButton.aspectFillToSize(size: CGSize(width: 100, height: 75))
        actionButton.name = "actionButton"
        actionButton.zPosition = 10
        actionButton.position = CGPoint(
            x: (size.width - 50 - (actionButton.size.width / 2)) - playableArea.width / 2,
            y: (20 + actionButton.size.height / 2) - playableArea.height / 2)
        cameraNode.addChild(actionButton)
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
        cameraNode.addChild(buttonLabel)
    }
    
    fileprivate func spawnPlayer() {
        player.createSprite(size: CGSize(width: 50, height: 50), location: CGPoint(x: gameArea.width / 2, y: gameArea.height / 2))
        self.addChild(player.spriteNode)
        player.drawReach()
        if player.nodeReach != nil {
            self.addChild(player.nodeReach!)
        }
    }
    
    fileprivate func spawnTent(newTent: Bool, _ position: CGPoint){
        var tent: HidingSpot
        if newTent {
            tent = HidingSpot(.tent, position, image: "tentNew", capacity: 1)
        } else {
            tent = HidingSpot(.tent, position, image: "tentOld", capacity: 1)
        }
        hidingSpots.append(tent)
        self.addChild(tent.spriteNode)
        self.addChild(tent.drawDebugArea())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: cameraNode)
            if joystickBackground.contains(location) {
                stickActive = true
            } else {
                stickActive = false
            }
            if actionButton.contains(location) {
                #if DEBUG
                print("button taped")
                #endif
                hidingSpots.forEach { (hidingSpot) in
                    hidingSpot.checkReach(player)
                    if hidingSpot.reachable {
                        if !freezeJoystick{
                            let hidePlayer = SKAction.hide()
                            player.spriteNode.run(hidePlayer)
                            freezeJoystick = true
                            #if DEBUG
                            print("Player is hidden")
                            print("Freezing controlls")
                            #endif
                        } else {
                            let showPlayer = SKAction.unhide()
                            player.spriteNode.run(showPlayer)
                            freezeJoystick = false
                            #if DEBUG
                            print("Player isn't hidden")
                            print("Unfreezing controlls")
                            #endif
                        }
                    }
                }
            }
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
                    joystick.position = CGPoint(
                        x: joystickBackground.position.x - distance.x,
                        y: joystickBackground.position.y + distance.y)
                }
                moveTo(location)
                player.spriteNode.zRotation = angle - 1.57079633
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: cameraNode)
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
        move(player.spriteNode, velocity)
        player.nodeReach?.position = player.spriteNode.position
        updateButtonLabel()
        cameraNode.position = player.spriteNode.position
    }
    
    fileprivate func updateButtonPosition() {
        actionButton.position = CGPoint(
            x: size.width - 50 - (actionButton.size.width / 2),
            y: 20 + actionButton.size.height / 2 + buttonLabel.frame.height)
        buttonLabel.position = CGPoint(
            x: actionButton.position.x,
            y: actionButton.position.y - actionButton.size.height / 2)
    }
    
    fileprivate func updateButtonLabel(){
        hidingSpots.forEach { (hidingSpot) in
            hidingSpot.checkReach(player)
        }
        if hidingSpots.contains(where: {$0.reachable == true}) {
            if !freezeJoystick{
                buttonLabel.text = "Hide"
            } else {
                buttonLabel.text = "Leave"
            }
            updateButtonPosition()
        } else {
            buttonLabel.text = ""
        }
    }
    
    func moveTo(_ location: CGPoint){
        let offset = location - joystickBackground.position
        let direction = offset.normalized()
        velocity = direction * player.movmentSpeed
    }
    
    func move(_ sprite: SKSpriteNode, _ location: CGPoint){
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    var cameraRect : CGRect {
        let x = cameraNode.position.x - size.width / 2 + (size.width - playableArea.width) / 2
        let y = cameraNode.position.y - size.height / 2 + (size.height - playableArea.height) / 2
        return CGRect(x: x, y: y, width: playableArea.width, height: playableArea.height)
    }
}
