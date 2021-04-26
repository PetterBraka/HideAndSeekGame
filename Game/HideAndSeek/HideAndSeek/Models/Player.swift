//
//  Player.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 22/03/2021.
//

import UIKit
import SpriteKit

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
    
    let originalSpeed: Speed
    
    var reach: Reach
    var role: Role
    var nodeReach: SKShapeNode!
    var reachable: Bool = false
    var spriteNode: SKSpriteNode
    var movmentSpeed: Speed

    internal init(reach: Player.Reach, role: Player.Role, movmentSpeed: Speed) {
        self.reach = reach
        self.role = role
        self.originalSpeed = movmentSpeed
        self.movmentSpeed = movmentSpeed
        switch role {
        case .hider:
            self.spriteNode = SKSpriteNode(imageNamed: "Hider")
        default:
            self.spriteNode = SKSpriteNode(imageNamed: "Seeker")
        }
    }
    
    /**
     Will create a SKSpriteNode of a spesific size and set the locaiton for the sprite.
     
     - Parameters:
         - size: - A CGSize of the size the sprite should have.
         - location: - A CGPoint of where the sprite should be located.
     */
    func createSprite(size: CGSize, location: CGPoint) {
        var image = ""
        switch role {
        case .hider:
            image = "Hider"
        default:
            image = "Seeker"
        }
        let player = SKSpriteNode(imageNamed: image)
        player.position = location
        player.zPosition = 1
        player.aspectFillToSize(size: size)
        player.name = "player"
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: image), size: size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = ColliderType.Player.rawValue
        player.physicsBody?.collisionBitMask = ColliderType.HidingPlace.rawValue
        spriteNode = player
        drawReach()
    }
    
    /**
     Will create a SKShapeNode of a circle with the radius of the sprite plus the reach the player has.
     
     # Notes: #
     1. Should be called after the spriteNode has been created.
     */
    private func drawReach(){
        let raidus = CGFloat(reach.rawValue) + (spriteNode.size.width / 2)
        let shape = SKShapeNode(circleOfRadius: raidus)
        shape.position = spriteNode.position
        shape.lineWidth = 2
        shape.strokeColor = .clear
        shape.zPosition = 99
        nodeReach = shape
    }
    
    /**
     Will change the movement speed for the player and make the player transparent.
     
     # Notes: #
     1. Will first set the movement speed to Speed.frozen
     2. Will run an animation of the player becoming transparent.
     */
    func caught(){
        movmentSpeed = .frozen
        spriteNode.run(.colorize(with: .clear, colorBlendFactor: 0.5, duration: 0.8))
    }
    
    /**
     Will change the movement speed back to the orignal speed for the player and make the player not be transparent.
     
     # Notes: #
     1. Will first set the movement speed to original speed.
     2. Will run an animation of the player becoming less transparent.
     */
    func freed(){
        movmentSpeed = originalSpeed
        spriteNode.run(.colorize(with: .clear, colorBlendFactor: 0, duration: 0.8))
    }
    
    /**
     Will print the details for the player.
     
     # Notes: #
     1. Will print to the output.
     2. Will only print if used in debug mode.
     
     */
    func toString(){
        #if DEBUG
        print("-------------------------------")
        print("Role: \(role)")
        print("Reach: \(reach)")
        print("Speed: \(movmentSpeed)")
        print("Image: \(String(describing: spriteNode.texture))")
        print("-------------------------------")
        #endif
    }
    
    /**
     Checks if the players reach inteferes with any bots in the scene.
     
     - Parameters:
         - scene:- The SKScene that contains the player and the bot.
         - bots:- An array of Bot to check.
     - returns: Optional Bot if a bots reach intersects the players reach.
     */
    func checkBotsIntersections(_ scene: SKScene, _ bots: [Bot]) -> Bot? {
        scene.enumerateChildNodes(withName: "bot") { [self] (node, _) in
            let sprite = node as! SKSpriteNode
            if let bot = bots.first(where: {$0.spriteNode == sprite}){
                if bot.nodeReach!.intersects(nodeReach!) {
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
    
    /**
     Checks if the players reach inteferes with any hiding spots in the scene.
     
     - Parameters:
         - scene: - The SKScene that contains the player and the hiding spot.
         - hidingSpots: - An array of HidingSpot to check.
     - returns: Optional HidingSpot if a hiding spots reach intersects the players reach.
     */
    func checkHidingSpotsIntersections(_ scene: SKScene, _ hidingSpots: [HidingSpot]) -> HidingSpot? {
        scene.enumerateChildNodes(withName: "hidingSpot") { [self] (node, _) in
            let sprite = node as! SKSpriteNode
            if let spot = hidingSpots.first(where: {$0.spriteNode == sprite}){
                if spot.nodeReach.intersects(nodeReach!) {
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
    
    /**
     Will check if a hidingSpot is within reach.
     
     - Parameters:
        hidingSpots: - An array of HidingSpot to check.
        freezeJoystick: - A Bool represening if the joystick can used or not.
     - returns: A String representing the action that can be preformed.
     */
    func checkHideAction(_ hidingSpots: [HidingSpot], _ freezeJoystick: Bool) -> String{
        if role == .hider {
            if hidingSpots.contains(where: {$0.reachable == true}) {
                if !freezeJoystick{
                    return "Hide"
                } else {
                    return "Leave"
                }
            }
        }
        return ""
    }
    
    /**
     Will check if a bot is within reach and can be chought or freed.
     
     - parameter Bot: - A bot to try an catch or freed.
     
     - returns: A String representing the action that can be preformed.
     */
    func checkCatchAction(_ bot: Bot) -> String{
        if role == .seeker {
            if bot.movmentSpeed != .frozen {
                return "Catch"
            }
        } else {
            if bot.movmentSpeed == .frozen {
                return "Free"
            }
        }
        return ""
    }
}
