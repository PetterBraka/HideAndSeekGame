//
//  GameScene.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 26/02/2021.
//

import SpriteKit
import GameplayKit

enum ChallangeRating : String {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
    
    static var count: Int {return ChallangeRating.hard.hashValue + 1}
}

enum Direction: String {
    case Up = "Up"
    case Down = "Down"
    case Left = "Left"
    case Right = "Right"
    case Still = "Still"
}

struct ColliderType {
    static let Player: UInt32 = 1
    static let HidingPlace: UInt32 = 2
}

class GameScene: SKScene {
    var numberOfPlayers: Int
    let gameDifficulty: ChallangeRating
    let duration: Int
    let joystickBackground = SKSpriteNode(imageNamed: "joystick_background")
    let joystick = SKSpriteNode(imageNamed: "joystick")
    let buttonLabel = SKLabelNode(fontNamed: "Chalkduster")
    let gameArea = CGRect(x: 0.5, y: 0.5, width: 1600, height: 800)
    let cameraNode = SKCameraNode()
    
    var seeker: Player?
    var bots: [Bot]
    var player: Player
    var movingDirection: Direction = .Still
    var nodesHit: [SKSpriteNode] = []
    var playableArea: CGRect
    var gameBounds: CGRect
    var actionButton = SKSpriteNode(color: .red, size: CGSize(width: 100,height: 75))
    var hidingSpots: [HidingSpot] = []
    var stickActive: Bool = false
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var velocity: CGPoint = .zero
    var freezeJoystick: Bool = false
    
    init(size: CGSize, difficulty: ChallangeRating, player: Player, duration: Int, amountOfPlayers: Int) {
        self.numberOfPlayers = amountOfPlayers
        self.gameDifficulty = difficulty
        self.duration = duration
        self.player = player
        self.playableArea = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
        self.gameBounds = playableArea
        self.bots = []
        super.init(size: size)
        self.playableArea = getPlayableArea()
        self.gameBounds = getCameraBounds()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getPlayableArea() -> CGRect{
        let aspectRatio = frame.width / frame.height
        let playableHeight = size.width / aspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        return CGRect(x: 0, y: playableMargin, width: frame.width, height: playableHeight)
    }
    
    private func getCameraBounds() -> CGRect {
        let rect = CGRect(x: frame.width / 2 , y: frame.height / 2,
                          width: playableArea.width - frame.width / 4,
                          height: playableArea.height)
        return rect
    }
    
    override func didMove(to view: SKView) {
        #if DEBUG
        print("============================")
        print("Duration: \(duration)")
        print("Difficulty: \(gameDifficulty)")
        print("Amount of player: \(numberOfPlayers)")
        player.toString()
        print("============================")
        #endif
        createMap()
        createJoystick()
        createButton()
        spawnPlayer()
        spawnBots()
        drawHouse()
        drawTents()
        addCamera()
        debugDrawPlayableArea()
        createBarriers()
    }
    
    fileprivate func addCamera(){
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = player.spriteNode.position
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
    
    fileprivate func createMap() {
        let background = SKSpriteNode(imageNamed: "gameBackground")
        background.position = CGPoint(x: gameArea.width / 2, y: gameArea.height / 2)
        background.zPosition = -1
        background.aspectFillToSize(size: gameArea.size)
        self.addChild(background)
        let mountain = HidingSpot(.mountain, CGPoint(x: 250, y: gameArea.height - 350), capacity: 0)
        mountain.spriteNode.position = CGPoint(x: mountain.spriteNode.size.width / 2,
                                               y: gameArea.height - mountain.spriteNode.size.height / 2)
        self.addChild(mountain.spriteNode)
        drawCampfire()
        drawRiver()
    }
    
    func createBarriers()  {
        drawBarrier(size: CGSize(width: gameArea.width, height: 5),
                   position: CGPoint(x: gameArea.width / 2, y: gameArea.height))
        drawBarrier(size: CGSize(width: gameArea.width, height: 5),
                   position: CGPoint(x: gameArea.width / 2, y: 0))
        drawBarrier(size: CGSize(width: 5 , height: gameArea.height),
                   position: CGPoint(x: 0, y: gameArea.height / 2))
        drawBarrier(size: CGSize(width: 5 , height: gameArea.height),
                   position: CGPoint(x: gameArea.width, y: gameArea.height / 2))
    }
    
    func drawBarrier(size: CGSize, position: CGPoint) {
        let barrier = SKSpriteNode(color: .clear, size: size)
        barrier.position = position
        barrier.physicsBody = SKPhysicsBody(rectangleOf: barrier.frame.size)
        barrier.physicsBody?.isDynamic = false
        barrier.physicsBody?.affectedByGravity = false
        barrier.physicsBody?.categoryBitMask = ColliderType.HidingPlace
        self.addChild(barrier)
    }
    
    fileprivate func drawCampfire(){
        let campfire = SKSpriteNode(imageNamed: "campfire")
        campfire.position = CGPoint(x: gameArea.width / 16 * 7, y: gameArea.height / 2)
        campfire.zPosition = 0
        campfire.aspectFillToSize(size: CGSize(width: 50, height: 50))
        self.addChild(campfire)
    }
    
    fileprivate func drawRiver(){
        let river = SKSpriteNode(imageNamed: "river")
        river.position = CGPoint(x: gameArea.width / 16 * 11, y: gameArea.height / 2)
        river.zPosition = 0
        river.size = CGSize(width: gameArea.width / 8, height: gameArea.height)
        self.addChild(river)
    }
    
    fileprivate func drawHouse() {
        let house = HidingSpot(.house, CGPoint(x: gameArea.width / 8 * 4, y: gameArea.height / 16 * 13), capacity: 2)
        self.addChild(house.spriteNode)
        hidingSpots.append(house)
        house.drawDebugArea(player.reach)
        self.addChild(house.nodeReach!)
    }
    
    fileprivate func drawTents(){
        spawnTent(newTent: true, CGPoint(x: (gameArea.width / 16 * 5),
                                         y: (gameArea.height / 4 * 3)))
        spawnTent(newTent: true, CGPoint(x: (gameArea.width / 16 * 3) + 50,
                                         y: (gameArea.height / 8 * 5) + 50))
        spawnTent(newTent: false, CGPoint(x: (gameArea.width / 16 * 5),
                                          y: (gameArea.height / 8 * 4)))
        spawnTent(newTent: false, CGPoint(x: (gameArea.width / 8 * 2),
                                          y: (gameArea.height / 8 * 3.5)))
    }
    
    fileprivate func spawnTent(newTent: Bool, _ position: CGPoint){
        let tent = HidingSpot(.tent, position, newTent: newTent , capacity: 1)
        hidingSpots.append(tent)
        self.addChild(tent.spriteNode)
        tent.drawDebugArea(player.reach)
        self.addChild(tent.nodeReach!)
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
        self.addChild(player.nodeReach!)
    }
    
    fileprivate func spawnBots() {
        let botSize = CGSize(width: 50, height: 50)
        let roleIndex = player.role.hashValue
        var role: Player.Role
        if roleIndex != Player.Role.seeker.hashValue {
            role = .seeker
            let seekerBot = Bot(reach: player.reach, role: role, movmentSpeed: player.movmentSpeed)
            seekerBot.createSprite(size: botSize,
                                 location: CGPoint(x: gameArea.width / 32 * 14, y: gameArea.height / 2 + 60))
            self.addChild(seekerBot.spriteNode)
            seekerBot.drawReach()
            self.addChild(seekerBot.nodeReach!)
            seeker = seekerBot
            bots.append(seekerBot)
        }
        while bots.count < numberOfPlayers {
            let bot = Bot(reach: player.reach, role: .hider, movmentSpeed: player.movmentSpeed)
            bot.createSprite(size: botSize,
                             location: CGPoint(x: self.gameArea.width / 32 * 13 + botSize.width * CGFloat(bots.count) + 20,
                                               y:  self.gameArea.height / 2 - 60))
            bots.append(bot)
            self.addChild(bot.spriteNode)
            bot.drawReach()
            self.addChild(bot.nodeReach!)
        }
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
                switch buttonLabel.text {
                case "Hide":
                    let hidePlayer = SKAction.hide()
                    player.spriteNode.run(hidePlayer)
                    freezeJoystick = true
                    #if DEBUG
                    print("Player is hidden")
                    print("Freezing controlls")
                    #endif
                case "Leave":
                    let showPlayer = SKAction.unhide()
                    player.spriteNode.run(showPlayer)
                    freezeJoystick = false
                    #if DEBUG
                    print("Player isn't hidden")
                    print("Unfreezing controlls")
                    #endif
                case "Catch":
                    if let bot = bots.first(where: {$0.reachable == true}){
                        bot.chought()
                    }
                case "Free":
                    if let bot = bots.first(where: {$0.reachable == true}){
                        bot.freed()
                    }
                default:
                    print("can't do anything")
                }
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
        if scene != nil {
            player.checkIntersections(scene!, bots)?.toString()
            player.checkIntersections(scene!, hidingSpots)?.toString()
        }
        hidePlayer()
        catchPlayer()
        constainGameArea()
    }
    
    fileprivate func constainGameArea(){
        let bottomLeft = CGPoint(x: playableArea.width / 2, y: playableArea.height / 2)
        let topRight = CGPoint(x: gameArea.width - playableArea.width / 2, y: gameArea.height - playableArea.height / 2)

        let positionX = player.spriteNode.position.x
        let positionY = player.spriteNode.position.y
        if (positionX >= bottomLeft.x && positionX <= topRight.x) &&
            (positionY >= bottomLeft.y && positionY <= topRight.y){
            cameraNode.position = player.spriteNode.position
        } else {
            if (positionX <= bottomLeft.x || positionX >= topRight.x) &&
                (positionY >= bottomLeft.y && positionY <= topRight.y) {
                cameraNode.position = CGPoint(x: cameraNode.position.x, y: player.spriteNode.position.y)
                #if DEBUG
                //print("Outside horizontal game area")
                #endif
            }
            if (positionX >= bottomLeft.x && positionX <= topRight.x) &&
                (positionY <= bottomLeft.y || positionY >= topRight.y) {
                cameraNode.position = CGPoint(x: player.spriteNode.position.x, y: cameraNode.position.y)
                #if DEBUG
                //print("Outside vertical game area")
                #endif
            }
        }
    }
    
    fileprivate func updateButtonPosition() {
        actionButton.position = CGPoint(
            x: (size.width - 50 - (actionButton.size.width / 2) - playableArea.width / 2),
            y: (20 + actionButton.size.height / 2 + buttonLabel.frame.height) - playableArea.height / 2)
        buttonLabel.position = CGPoint(
            x: actionButton.position.x,
            y: actionButton.position.y - actionButton.size.height / 2)
    }
    
    fileprivate func hidePlayer(){
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
            actionButton.position = CGPoint(
                x: (size.width - 50 - (actionButton.size.width / 2)) - playableArea.width / 2,
                y: (20 + actionButton.size.height / 2) - playableArea.height / 2)
        }
    }
    
    fileprivate func catchPlayer(){
        bots.forEach { (bot) in
            bot.checkReach(player)
        }
        if bots.contains(where: {$0.reachable == true}){
        let bot = bots.first(where: {$0.reachable == true})
            if bot?.movmentSpeed == .frozen {
                buttonLabel.text = "Free"
            } else {
                buttonLabel.text = "Catch"
            }
            updateButtonPosition()
        } else {
            buttonLabel.text = ""
            actionButton.position = CGPoint(
                x: (size.width - 50 - (actionButton.size.width / 2)) - playableArea.width / 2,
                y: (20 + actionButton.size.height / 2) - playableArea.height / 2)
        }
    }
    
    func getDirection(for value: CGFloat) -> Direction{
        if (value * 100) < 100 && (value * 100) > -100{
            print("Up")
            return .Up
        } else if (value * 100) < -100 && (value * 100) > -200 {
            print("Right")
            return .Right
        } else if (value * 100) < -200 && (value * 100) > -400 {
            print("Down")
            return .Down
        } else if (value * 100) < -400 || (value * 100) > 100{
            print("Left")
            return .Left
        }
        return .Still
    }
    
    fileprivate func moveJoystick(_ location: CGPoint) {
        if !freezeJoystick {
            if stickActive {
                let radius = CGVector(dx: location.x - joystickBackground.position.x,
                                      dy: location.y - joystickBackground.position.y)
                let angle: CGFloat = atan2(radius.dy, radius.dx) - 1.57079633
                let length: CGFloat = joystickBackground.frame.size.width / 2
                let distance = CGPoint(
                    x: sin(angle) * length,
                    y: cos(angle) * length)
                if joystickBackground.frame.contains(location) {
                        joystick.position = location
                } else {
                    joystick.position = CGPoint(
                        x: joystickBackground.position.x - distance.x,
                        y: joystickBackground.position.y + distance.y)
                }
                moveTo(location)
                player.spriteNode.zRotation = angle
                movingDirection = getDirection(for: angle)
            }
        }
    }
    
    func moveTo(_ location: CGPoint){
        let offset = location - joystickBackground.position
        let direction = offset.normalized()
        velocity = direction * player.movmentSpeed.rawValue
    }
    
    func move(_ sprite: SKSpriteNode, _ location: CGPoint){
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
}
