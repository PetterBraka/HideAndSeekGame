//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit


enum ChallangeRating : String {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
    
    static var count: Int {return ChallangeRating.hard.hashValue + 1}
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
    var bots: [Player]
    var player: Player
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
        createMap()
        createJoystick()
        createButton()
        addCamera()
        createBarriers()
    }
    
    fileprivate func addCamera(){
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = player.spriteNode.position
    }
    
    //: Creating the map for the game
    fileprivate func createMap() {
        let background = SKSpriteNode(imageNamed: "map")
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
        spawnPlayer()
        spawnBots()
        drawHouse()
        drawTents()
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
        house.drawDebugArea()
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
        tent.drawDebugArea()
        self.addChild(tent.nodeReach!)
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
            let seekerBot = Player(reach: player.reach, role: role, movmentSpeed: player.movmentSpeed)
            seekerBot.createSprite(size: botSize,
                                   location: CGPoint(x: gameArea.width / 32 * 14, y: gameArea.height / 2 + 60))
            self.addChild(seekerBot.spriteNode)
            seekerBot.drawReach()
            self.addChild(seekerBot.nodeReach!)
            seeker = seekerBot
            bots.append(seekerBot)
        }
        while bots.count < numberOfPlayers {
            let bot = Player(reach: player.reach, role: .hider, movmentSpeed: player.movmentSpeed)
            bot.createSprite(size: botSize,
                             location: CGPoint(x: self.gameArea.width / 32 * 13 + botSize.width * CGFloat(bots.count) + 20,
                                               y:  self.gameArea.height / 2 - 60))
            bots.append(bot)
            self.addChild(bot.spriteNode)
            bot.drawReach()
            self.addChild(bot.nodeReach!)
        }
    }
    
    //: Creates the UI
    fileprivate func createJoystick() {
        joystickBackground.name = "joystick"
        joystickBackground.size = CGSize(width: 110, height: 110)
        joystickBackground.position = CGPoint(
            x: (joystickBackground.size.width / 2 + 50) - playableArea.width / 2,
            y: (joystickBackground.size.height / 2 + 50) - playableArea.height / 2)
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
            y: ( joystickBackground.position.y))
        cameraNode.addChild(actionButton)
        createButtonLable()
    }
    
    fileprivate func createButtonLable() {
        buttonLabel.text = ""
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: cameraNode)
            if joystickBackground.contains(location) {
                stickActive = true
            } else {
                stickActive = false
            }
            if actionButton.contains(location) {
                switch buttonLabel.text {
                case "Hide":
                    let hidePlayer = SKAction.hide()
                    player.spriteNode.run(hidePlayer)
                    freezeJoystick = true
                case "Leave":
                    let showPlayer = SKAction.unhide()
                    player.spriteNode.run(showPlayer)
                    freezeJoystick = false
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
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        if let bot = checkBotsIntersections(){
            catchPlayer(bot)
        } else if checkHidingSpotsIntersections() != nil {
            hidePlayer()
        } else {
            buttonLabel.text = ""
        }
        constrainGameArea()
    }
    
    func checkBotsIntersections() -> Player? {
        enumerateChildNodes(withName: "bot") { [self] (node, _) in
            let sprite = node as! SKSpriteNode
            if let bot = bots.first(where: {$0.spriteNode == sprite}){
                if bot.nodeReach!.intersects(player.nodeReach!) {
                    bot.reachable = true
                } else {
                    bot.reachable = false
                }
            }
        }
        if let bot = bots.first(where: {$0.reachable == true}){
            return bot
        }
        return nil
    }
    
    func checkHidingSpotsIntersections() -> HidingSpot? {
        enumerateChildNodes(withName: "hidingSpot") { [self] (node, _) in
            let sprite = node as! SKSpriteNode
            if let spot = hidingSpots.first(where: {$0.spriteNode == sprite}){
                if spot.nodeReach!.intersects(player.nodeReach!) {
                    spot.reachable = true
                } else {
                    spot.reachable = false
                }
            }
        }
        if let spot = hidingSpots.first(where: {$0.reachable == true}){
            return spot
        }
        return nil
    }
    
    fileprivate func constrainGameArea(){
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
            }
            if (positionX >= bottomLeft.x && positionX <= topRight.x) &&
                (positionY <= bottomLeft.y || positionY >= topRight.y) {
                cameraNode.position = CGPoint(x: player.spriteNode.position.x, y: cameraNode.position.y)
            }
        }
    }
    
    fileprivate func hidePlayer(){
        if player.role == .hider {
            if hidingSpots.contains(where: {$0.reachable == true}) {
                if !freezeJoystick{
                    buttonLabel.text = "Hide"
                } else {
                    buttonLabel.text = "Leave"
                }
            }
        }
    }
    
    fileprivate func catchPlayer(_ bot: Player){
        if player.role == .seeker {
            if bot.movmentSpeed != .frozen {
                buttonLabel.text = "Catch"
            }
        } else {
            if bot.movmentSpeed == .frozen {
                buttonLabel.text = "Free"
            }
        }
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
            }
        }
    }
    
    func moveTo(_ location: CGPoint){
        let offset = CGPoint(x: location.x - joystickBackground.position.x,
                             y: location.y - joystickBackground.position.y)
        let direction = CGPoint(x: offset.x / sqrt(offset.x * offset.x + offset.y * offset.y),
                                y: offset.y / sqrt(offset.x * offset.x + offset.y * offset.y))
        velocity = CGPoint(x: direction.x * player.movmentSpeed.rawValue,
                           y: direction.y * player.movmentSpeed.rawValue)
    }
    
    func move(_ sprite: SKSpriteNode, _ location: CGPoint){
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
                                  y: sprite.position.y + amountToMove.y)
    }
}

class Player: NSObject {
    enum Role: String {
        case hider = "Hider"
        case seeker = "Seeker"
    }

    enum Reach: Float {
        case short = 10
        case medium = 20
        case far = 30
    }
    
    enum Speed: CGFloat {
        case slow = 100
        case normal = 200
        case fast = 300
        case frozen = 0
    }
    
    var reach: Reach
    var role: Role
    let speed: Speed
    var movmentSpeed: Speed
    var spriteNode: SKSpriteNode
    var nodeReach: SKShapeNode?
    var reachable: Bool = false
    
    internal init(reach: Player.Reach, role: Player.Role, movmentSpeed: Speed) {
        self.reach = reach
        self.role = role
        self.speed = movmentSpeed
        self.movmentSpeed = movmentSpeed
        switch role {
        case .hider:
            self.spriteNode = SKSpriteNode(imageNamed: "Hider")
        default:
            self.spriteNode = SKSpriteNode(imageNamed: "Seeker")
        }
    }
    
    func createSprite(size: CGSize, location: CGPoint) {
        let player = SKSpriteNode(imageNamed: role.rawValue)
        player.position = location
        player.zPosition = 1
        player.aspectFillToSize(size: size)
        player.name = "player"
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = ColliderType.Player
        player.physicsBody?.collisionBitMask = ColliderType.HidingPlace
        
        spriteNode = player
    }
    
    func chought(){
        movmentSpeed = .frozen
        spriteNode.run(.colorize(with: .clear, colorBlendFactor: 0.5, duration: 0.8))
    }
    
    func freed(){
        movmentSpeed = speed
        spriteNode.run(.colorize(with: .clear, colorBlendFactor: 0, duration: 0.8))
    }
    
    func drawReach(){
        let raidus = CGFloat(reach.rawValue) + (spriteNode.size.width / 2)
        let shape = SKShapeNode(circleOfRadius: raidus)
        shape.position = spriteNode.position
        shape.lineWidth = 2
        shape.strokeColor = .clear
        shape.zPosition = 99
        nodeReach = shape
    }
}

class HidingSpot: NSObject {
    enum Variant: String {
        case mountain = "mountain"
        case house = "house"
        case tent = "tent"
        case tree = "tree"
        case lake = "lake"
    }
    
    let type: Variant
    let location: CGPoint
    let capacity: Int
    
    var spriteNode: SKSpriteNode = SKSpriteNode()
    var image: String
    var reachable: Bool
    var nodeReach: SKShapeNode?
    
    init(_ variant: Variant, _ location: CGPoint, capacity: Int) {
        self.type = variant
        self.image = variant.rawValue
        self.capacity = capacity
        self.location = location
        self.reachable = false
        super.init()
        self.spriteNode = createSprite()
    }
    
    init(_ variant: Variant, _ location: CGPoint, newTent: Bool, capacity: Int) {
        self.type = variant
        self.capacity = capacity
        self.location = location
        self.reachable = false
        switch variant {
        case .tent:
            if newTent {
                image = "tentNew"
            } else {
                image = "tentOld"
            }
        default:
            self.image = variant.rawValue
        }
        super.init()
        self.spriteNode = createSprite()
    }
    
    private func getSize() -> CGSize {
        switch type {
        case .mountain:
            return CGSize(width: 500, height: 700)
        case .house:
            return CGSize(width: 250, height: 250)
        case .tent:
            return CGSize(width: 80, height: 80)
        case .tree:
            return CGSize(width: 60, height: 120)
        case .lake:
            return CGSize(width: 4000, height: 150)
        }
    }
    
    private func createSprite() -> SKSpriteNode {
        let place = SKSpriteNode(imageNamed: image)
        place.position = location
        place.name = "hidingSpot"
        place.aspectFillToSize(size: getSize())
        place.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        place.zPosition = 1
        switch type {
        case .house:
            place.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: place.size.width - 30, height: place.size.height - 50))
        case .tent:
            place.physicsBody = SKPhysicsBody(circleOfRadius: place.size.width / 2)
        default:
            place.physicsBody = SKPhysicsBody(texture: place.texture!, size: place.size)
        }
        place.physicsBody?.isDynamic = false
        place.physicsBody?.affectedByGravity = false
        place.physicsBody?.categoryBitMask = ColliderType.HidingPlace
        return place
    }
    
    func drawDebugArea() {
        let shape = SKShapeNode(circleOfRadius: (spriteNode.size.width / 2))
        shape.position = CGPoint(
            x: spriteNode.position.x,
            y: spriteNode.position.y)
        shape.lineWidth = 2
        shape.strokeColor = .clear
        shape.zPosition = 99
        nodeReach = shape
    }
}

extension SKSpriteNode {
    func aspectFillToSize(size: CGSize) {
        guard let texture = self.texture else {
            print("Can't set aspect ratio of node. No textures found for node")
            return
        }
        self.size = texture.size()
        let heightRatio = size.height / texture.size().height
        let widthRatio = size.width / texture.size().width
        
        let scaleingRatio = widthRatio > heightRatio ? widthRatio : heightRatio
        
        setScale(scaleingRatio)
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
let player = Player(reach: .medium, role: .hider, movmentSpeed: .normal)
let scene = GameScene(size: sceneView.bounds.size,
                         difficulty: .normal,
                         player: player,
                         duration: 1,
                         amountOfPlayers: 3)
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

