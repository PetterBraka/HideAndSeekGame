//
//  GameScene.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 26/02/2021.
//

import SpriteKit

enum ChallangeRating : String {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
}

enum ColliderType: UInt32 {
    case Player = 1
    case HidingPlace = 2
}

class GameScene: SKScene {
    // MARK: - Variabels
    private let duration: Int
    private let gameStartDate: Date
    private let gameDifficulty: ChallangeRating
    private let numberOfPlayers: Int
    private let gameArea = CGRect(x: 0.5, y: 0.5, width: 1600, height: 800)
    // - SKNodes
    private let cameraNode = SKCameraNode()
    // - Buttons & labels
    private let joystick = SKSpriteNode(imageNamed: "joystick")
    private let buttonLabel = SKLabelNode(fontNamed: "Chalkduster")
    private let durationLabel = SKLabelNode(fontNamed: "Chalkduster")
    private let joystickBackground = SKSpriteNode(imageNamed: "joystick_background")
    private var actionButton = SKSpriteNode(color: .red, size: CGSize(width: 100,height: 75))
    
    private var bots: [Bot]
    private var seeker: Bot?
    private var player: Player
    private var nodesHit: [SKSpriteNode] = []
    private var hidingSpots: [HidingSpot] = []
    private var freezeJoystick: Bool = false
    private var playableArea: CGRect
    private var velocity: CGPoint = .zero
    private var lastUpdateTime: TimeInterval = 0
    
    init(size: CGSize, difficulty: ChallangeRating, player: Player, duration: Int, numberOfBots: Int) {
        self.numberOfPlayers = numberOfBots
        self.gameDifficulty = difficulty
        self.duration = duration
        self.player = player
        self.bots = []
        self.gameStartDate = Date()
        self.playableArea = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
        super.init(size: size)
        self.playableArea = getPlayableArea()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Game mechanics
    override func didMove(to view: SKView) {
        #if DEBUG
        // This will print out the game details if run in debug mode.
        print("============================")
        print("Duration: \(duration)")
        print("Difficulty: \(gameDifficulty)")
        print("Amount of player: \(numberOfPlayers)")
        player.toString()
        print("============================")
        #endif
        createMap()
        createUI()
    }
    
    // MARK: - Touch handeling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: cameraNode)
            // Check if the loaction of the touch is at the loaction of the joystickBackground node or the actionButton node.
            if joystickBackground.contains(location) {
                freezeJoystick = false
                moveJoystick(location)
            } else if actionButton.contains(location) {
                // Checks the buttonLabel
                #if DEBUG
                print("button taped")
                #endif
                print(buttonLabel.text!)
                switch buttonLabel.text! {
                case "Hide":
                    // Will hide the player.
                    let hidePlayer = SKAction.hide()
                    player.spriteNode.run(hidePlayer)
                    freezeJoystick = true
                    #if DEBUG
                    print("Player is hidden")
                    print("Freezing controlls")
                    #endif
                case "Leave":
                    // Will show the player
                    let showPlayer = SKAction.unhide()
                    player.spriteNode.run(showPlayer)
                    freezeJoystick = false
                    #if DEBUG
                    print("Player isn't hidden")
                    print("Unfreezing controlls")
                    #endif
                case "Catch":
                    // Gets the bot which is reacable and who isn't caught.
                    if let bot = bots.first(where: {$0.reachable == true && $0.movmentSpeed != .frozen}){
                        bot.caught()
                    }
                case "Free":
                    // Gets the bot which is reacable and who is caught.
                    if let bot = bots.first(where: {$0.reachable == true && $0.movmentSpeed == .frozen
                    }){
                        bot.freed()
                    }
                default:
                    #if DEBUG
                    print("can't do anything")
                    #endif
                }
                freezeJoystick = true
            } else {
                freezeJoystick = true
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
        if !freezeJoystick {
            let move = SKAction.move(to: joystickBackground.position, duration: 0.2)
            joystick.run(move)
        }
        velocity = CGPoint.zero
    }
    
    override func update(_ currentTime: TimeInterval) {
        var timeDifference: TimeInterval = 0
        if lastUpdateTime > 0 {
            timeDifference = currentTime - lastUpdateTime
        }
        lastUpdateTime = currentTime
        move(timeDifference, player.spriteNode)
        // Checks if the player intersects whit a bot or an hiding spot
        if let bot = player.checkBotsIntersections(scene!, bots){
            buttonLabel.text = player.checkCatchAction(bot)
        } else if player.checkHidingSpotsIntersections(scene!, hidingSpots) != nil {
            buttonLabel.text = player.checkHideAction(hidingSpots, freezeJoystick)
        } else {
            buttonLabel.text = ""
        }
        constrinCameraNode()
        updateDurationLabel()
    }
    
    /**
     This will update the position of the camera and check that the camera is inside of the game area.
     
     # Notes: #
     1. Should be used after the player has moved.
     
     # Example #
     ```
     override func update(_ currentTime: TimeInterval) {
        move(timeDifference, player.spriteNode, velocity)
        constrinCameraNode()
     }
     ```
     */
    private func constrinCameraNode(){
        let bottomLeft = CGPoint(x: playableArea.width / 2, y: playableArea.height / 2)
        let topRight = CGPoint(x: gameArea.width - playableArea.width / 2, y: gameArea.height - playableArea.height / 2)
        
        let positionX = player.spriteNode.position.x
        let positionY = player.spriteNode.position.y
        // Checks if the camera node is incide of the game area, and if so then sets the cameras position to be the same as the player.
        if (positionX >= bottomLeft.x && positionX <= topRight.x) &&
            (positionY >= bottomLeft.y && positionY <= topRight.y){
            cameraNode.position = player.spriteNode.position
        } else {
            // If outside of the game area the camera will be restricted to move vertically or horizontally.
            if (positionX <= bottomLeft.x || positionX >= topRight.x) &&
                (positionY >= bottomLeft.y && positionY <= topRight.y) {
                cameraNode.position = CGPoint(x: cameraNode.position.x, y: player.spriteNode.position.y)
                #if DEBUG
                print("Outside horizontal game area")
                #endif
            }
            if (positionX >= bottomLeft.x && positionX <= topRight.x) &&
                (positionY <= bottomLeft.y || positionY >= topRight.y) {
                cameraNode.position = CGPoint(x: player.spriteNode.position.x, y: cameraNode.position.y)
                #if DEBUG
                print("Outside vertical game area")
                #endif
            }
        }
    }
    
    /**
     Will create a victory label depening on who won the game.
     
     # Notes: #
     1. Should be called in when checking the duration of the game
     
     */
    private func checkVictory(){
        var forzenBots = 0
        bots.forEach { (bot) in
            if bot.movmentSpeed == .frozen{
                forzenBots = forzenBots + 1
            }
        }
        // Goes though all the bots and checks if all are chough.
        if forzenBots == bots.count{
            createVictoryLabel("Seekers Won")
        } else {
            createVictoryLabel("Hiders Won")
        }
    }
    
    // MARK: - Movement
    
    /**
     Will move the joystick and make sure the joystick stays inside of the joysticks background.
     
     - parameter location: - A CGPoint. Should be the a touch location.
     
     # Notes: #
     1. This should be called whenever there is a touch action preformed.
     
     # Example #
     ```
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
             let location = touch.location(in: cameraNode)
             moveJoystick(location)
         }
     }
     ```
     */
    private func moveJoystick(_ location: CGPoint) {
        if !freezeJoystick {
            let radius = CGVector(dx: location.x - joystickBackground.position.x,
                                  dy: location.y - joystickBackground.position.y)
            let angle: CGFloat = atan2(radius.dy, radius.dx) - 1.57079633
            // Checks if the location passed in is inside of the joyticks background.
            // If so then sets the joysticks position to that location.
            if joystickBackground.frame.contains(location) {
                joystick.position = location
            } else {
                // If the location is outside of the background it will move the joystick towards the location, but not outside of the joysticks background
                let length: CGFloat = joystickBackground.frame.size.width / 2
                let distance = CGPoint(
                    x: sin(angle) * length,
                    y: cos(angle) * length)
                joystick.position = CGPoint(
                    x: joystickBackground.position.x - distance.x,
                    y: joystickBackground.position.y + distance.y)
            }
            moveTo(location)
            player.spriteNode.zRotation = angle
            #if DEBUG
            print(getDirection(for: angle))
            #endif
        }
    }
    
    /**
     Will get the difference in location position and the joysticks postion, then calculate the velocity and the direction of it.
     
     - parameter location: - CGPoint.
     */
    private func moveTo(_ location: CGPoint){
        let offset = location - joystickBackground.position
        let direction = offset.normalized()
        velocity = direction * player.movmentSpeed.rawValue
    }
    
    /**
     Will move a SKSpriteNode in a direction. It will also calculate how cuickly to move.
     
     - Parameters:
       - timeDifference: The time difference since last update.
       - sprite: The SKSpriteNode to be moved.
     */
    private func move(_ timeDifference: TimeInterval, _ sprite: SKSpriteNode){
        let amountToMove = velocity * CGFloat(timeDifference)
        sprite.position += amountToMove
        player.nodeReach?.position = sprite.position
    }
    
    /**
     Returns a string depening on the value passed in.
     
     - parameter value: - A CGFloat representing the angle.
     
     # Notes: #
     1. Use for debuging.
     2. Don't use this for navigation.
     
     # Example #
     ```
     #if DEBUG
     print(getDirection(angle)
     #endif
     ```
     */
    private func getDirection(for value: CGFloat) -> String{
        if (value * 100) < 100 && (value * 100) > -100{
            return "Up"
        } else if (value * 100) < -100 && (value * 100) > -200 {
            return "Right"
        } else if (value * 100) < -200 && (value * 100) > -400 {
            return "Down"
        } else if (value * 100) < -400 || (value * 100) > 100{
            return "Left"
        }
        return "Still"
    }
}

// MARK: - UI creation
// This extension contains functions for the UI.
extension GameScene {
    
    /**
     Calles the different functions responsible for creating elements of the UI.
     */
    private func createUI() {
        createJoystick()
        createButton()
        addCamera()
        createDurationLabel()
    }
    
    /**
     Will create a joystick and adds it to the camera node. The joytick is to be used to control the player.
     */
    private func createJoystick() {
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
    
    /**
     Creates a button and adds it to the camera node.
     */
    private func createButton() {
        actionButton = SKSpriteNode(imageNamed: "button")
        actionButton.aspectFillToSize(size: CGSize(width: 100, height: 75))
        actionButton.name = "actionButton"
        actionButton.zPosition = 10
        actionButton.position = CGPoint(
            x: (size.width - 50 - (actionButton.size.width / 2)) - playableArea.width / 2,
            y: ( joystickBackground.position.y))
        cameraNode.addChild(actionButton)
        createButtonLabel()
    }
    
    /**
     Creates a Label and posisions it underneat the button. This label will tell what action can be preformed by the player.
    
     # Notes: #
     1. Should be used tell the player what they can do.
     2. Should be blank if no action can be preformed.
    
     */
    private func createButtonLabel() {
        buttonLabel.text = "Action button"
        buttonLabel.name = "ButtonLabel"
        buttonLabel.fontColor = .white
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
    
    /**
     Creates a label to display the duration of the game.
     
     # Notes: #
     1. This will create a label with white text and black background and it will add it to the camera node.
     */
    private func createDurationLabel(){
        durationLabel.text = "Time left: \(duration)"
        durationLabel.fontColor = .white
        durationLabel.fontSize = 20
        durationLabel.zPosition = 99
        durationLabel.numberOfLines = 1
        durationLabel.horizontalAlignmentMode = .center
        durationLabel.verticalAlignmentMode = .center
        durationLabel.position = CGPoint(x: 0, y: playableArea.height / 2 - 25)
        let background = SKShapeNode(rect: CGRect(x: 0, y: 0,
                                                  width: durationLabel.frame.size.width + 10,
                                                  height: durationLabel.frame.size.height + 5),
                                     cornerRadius: 5)
        background.fillColor = .black
        background.name = "textBackground"
        background.lineWidth = 0
        background.alpha = 0.6
        background.position = CGPoint(x: -background.frame.width / 2,
                                      y: -background.frame.height / 2)
        durationLabel.addChild(background)
        cameraNode.addChild(durationLabel)
    }
    
    /**
     Will update the duration label, and replace the black background with one that fits the text.
     
     # Notes: #
     1. Should be called in update().
     2. Will display the time in seconds.
     
     # Example #
     ```
     update(){
        updateDurationLabel
     }
     ```
     */
    private func updateDurationLabel(){
        let secondsSinceStart = Int(abs(gameStartDate.timeIntervalSince1970 - Date().timeIntervalSince1970))
        let timeLeft = duration - secondsSinceStart
        if timeLeft < 0 {
            checkVictory()
        } else {
            durationLabel.text = "Time left: \(timeLeft)"
        }
        if var background = durationLabel.childNode(withName: "textBackground") as? SKShapeNode {
            background.removeFromParent()
            background = SKShapeNode(rect: CGRect(x: 0, y: 0,
                                                  width: durationLabel.frame.size.width + 10,
                                                  height: durationLabel.frame.size.height + 5),
                                     cornerRadius: 5)
            background.fillColor = .black
            background.name = "textBackground"
            background.lineWidth = 0
            background.alpha = 0.6
            background.position = CGPoint(x: -background.frame.width / 2,
                                          y: -background.frame.height / 2)
            durationLabel.addChild(background)
        }
        
    }
    
    /**
     Creates a label to display who won the game.
     
     - parameter title: - A string describing who won the game.
     
     # Notes: #
     1. Will add it to the camera node.
     2. When 5 seconds has gone after the label has been displayed it will go back to the main menu.
     */
    private func createVictoryLabel(_ title: String){
        let victoryLabel = SKLabelNode(fontNamed: "Chalkduster")
        victoryLabel.text = title
        victoryLabel.fontColor = .white
        victoryLabel.fontSize = 30
        victoryLabel.zPosition = 99
        victoryLabel.numberOfLines = 1
        victoryLabel.horizontalAlignmentMode = .center
        victoryLabel.verticalAlignmentMode = .center
        victoryLabel.position = CGPoint(x: 0, y: 0)
        let background = SKShapeNode(rect: CGRect(x: 0, y: 0,
                                                  width: victoryLabel.frame.size.width + 10,
                                                  height: victoryLabel.frame.size.height + 5),
                                     cornerRadius: 5)
        background.fillColor = .black
        background.name = "textBackground"
        background.lineWidth = 0
        background.alpha = 0.6
        background.position = CGPoint(x: -background.frame.width / 2,
                                      y: -background.frame.height / 2)
        victoryLabel.addChild(background)
        cameraNode.addChild(victoryLabel)
        freezeJoystick = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
     Adds a camera node to the scene and sets the position to the players position.
     */
    private func addCamera(){
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = player.spriteNode.position
    }
    
    /**
     Will get a frame of the actuall screen sice and return a CGRect.
     
     - returns: CGRect with the dimentions of the screen.
     */
    private func getPlayableArea() -> CGRect{
        let aspectRatio = frame.width / frame.height
        let playableHeight = size.width / aspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        return CGRect(x: 0, y: playableMargin, width: frame.width, height: playableHeight)
    }
}

// MARK: - Scene creation
// This extension containts funcitons for creation of the scene.
extension GameScene {
    
    /**
     Calles all the functions responsible for adding nodes to the scene.
     
     # Notes: #
     1. Shuld be called when the scene has been loaded.
     
     */
    private func createMap() {
        drawEnvironment()
        drawCampfire()
        drawRiver()
        drawHouse()
        drawTents()
        createBarriers()
        spawnPlayer()
        spawnBots()
    }
    
    /**
     Will add the background and a montain.
     */
    private func drawEnvironment() {
        let background = SKSpriteNode(imageNamed: "gameBackground")
        background.position = CGPoint(x: gameArea.width / 2, y: gameArea.height / 2)
        background.zPosition = -1
        background.aspectFillToSize(size: gameArea.size)
        self.addChild(background)
        let mountain = HidingSpot(.mountain, CGPoint(x: 250, y: gameArea.height - 350), capacity: 0)
        mountain.spriteNode.position = CGPoint(x: mountain.spriteNode.size.width / 2,
                                               y: gameArea.height - mountain.spriteNode.size.height / 2)
        self.addChild(mountain.spriteNode)
    }
    
    /**
     Adds a campfire node to the centre of the scene.
     */
    private func drawCampfire(){
        let campfire = SKSpriteNode(imageNamed: "campfire")
        campfire.position = CGPoint(x: gameArea.width / 16 * 7, y: gameArea.height / 2)
        campfire.zPosition = 0
        campfire.aspectFillToSize(size: CGSize(width: 50, height: 50))
        self.addChild(campfire)
    }
    
    /**
     Adds a river node to the scene.
     */
    private func drawRiver(){
        let river = SKSpriteNode(imageNamed: "river")
        river.position = CGPoint(x: gameArea.width / 16 * 11, y: gameArea.height / 2)
        river.zPosition = 0
        river.size = CGSize(width: gameArea.width / 8, height: gameArea.height)
        self.addChild(river)
    }
    
    /**
     Adds a house node to the scene
     */
    private func drawHouse() {
        let house = HidingSpot(.house, CGPoint(x: gameArea.width / 8 * 4, y: gameArea.height / 16 * 13), capacity: 2)
        self.addChild(house.spriteNode)
        hidingSpots.append(house)
        self.addChild(house.nodeReach)
    }
    
    /**
     Adds 4 tents nodes of different styles at different positions in the scene.
     */
    private func drawTents(){
        drawATent(newTent: true, CGPoint(x: (gameArea.width / 16 * 5),
                                         y: (gameArea.height / 4 * 3)))
        drawATent(newTent: true, CGPoint(x: (gameArea.width / 16 * 3) + 50,
                                         y: (gameArea.height / 8 * 5) + 50))
        drawATent(newTent: false, CGPoint(x: (gameArea.width / 16 * 5),
                                          y: (gameArea.height / 8 * 4)))
        drawATent(newTent: false, CGPoint(x: (gameArea.width / 8 * 2),
                                          y: (gameArea.height / 8 * 3.5)))
    }
    
    /**
     Will draw a tent and at it to the scene.
     
     - Parameters:
        - newTent: A bool representing a new tent.
        - position: A CGPoint for the location of where the tent will be added.
     */
    private func drawATent(newTent: Bool, _ position: CGPoint){
        let tent = HidingSpot(.tent, position, newTent: newTent , capacity: 1)
        hidingSpots.append(tent)
        self.addChild(tent.spriteNode)
        self.addChild(tent.nodeReach)
    }
    
    /**
     Adds a player node to the scene.
     */
    private func spawnPlayer() {
        player.createSprite(size: CGSize(width: 50, height: 50), location: CGPoint(x: gameArea.width / 2, y: gameArea.height / 2))
        self.addChild(player.spriteNode)
        self.addChild(player.nodeReach)
    }
    
    /**
     Will add all the bots to the scene. Depening on the role of the player it will add a different bots.
     
     # Notes: #
     1. Should be called after the player has been added to the scene.
     
     # Example #
     ```
     ...
     spawnPlayer()
     spawnBots()
     ...
     ```
     */
    private func spawnBots() {
        let botSize = CGSize(width: 50, height: 50)
        let roleIndex = player.role.hashValue
        var role: Player.Role
        if roleIndex != Player.Role.seeker.hashValue {
            role = .seeker
            let seekerBot = Bot(reach: player.reach, role: role, movmentSpeed: player.movmentSpeed)
            seekerBot.createSprite(size: botSize,
                                   location: CGPoint(x: gameArea.width / 32 * 14, y: gameArea.height / 2 + 60))
            self.addChild(seekerBot.spriteNode)
            self.addChild(seekerBot.nodeReach)
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
            self.addChild(bot.nodeReach)
            if bots.count == numberOfPlayers - 1{
                bot.caught()
            }
        }
    }
    
    /**
     Creates a bariarre around the gameArea and assigns it a physics body.
     */
    private func createBarriers()  {
        drawBarrier(size: CGSize(width: gameArea.width, height: 5),
                    position: CGPoint(x: gameArea.width / 2, y: gameArea.height))
        drawBarrier(size: CGSize(width: gameArea.width, height: 5),
                    position: CGPoint(x: gameArea.width / 2, y: 0))
        drawBarrier(size: CGSize(width: 5 , height: gameArea.height),
                    position: CGPoint(x: 0, y: gameArea.height / 2))
        drawBarrier(size: CGSize(width: 5 , height: gameArea.height),
                    position: CGPoint(x: gameArea.width, y: gameArea.height / 2))
    }
    
    /**
     Will create a barrier and add to the scene.
     
     - Parameters:
        - size: A CGSize for the size of the barrier.
        - position: A CGPoint for the location for the barrier.
     */
    private func drawBarrier(size: CGSize, position: CGPoint) {
        let barrier = SKSpriteNode(color: .clear, size: size)
        barrier.position = position
        barrier.physicsBody = SKPhysicsBody(rectangleOf: barrier.frame.size)
        barrier.physicsBody?.isDynamic = false
        barrier.physicsBody?.affectedByGravity = false
        barrier.physicsBody?.categoryBitMask = ColliderType.HidingPlace.rawValue
        self.addChild(barrier)
    }
}
