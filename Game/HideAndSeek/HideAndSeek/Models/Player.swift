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
    var movmentSpeed: Speed
    var spriteNode: SKSpriteNode
    var nodeReach: SKShapeNode?
    var reachable: Bool = false

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
    }
    
    func caught(){
        movmentSpeed = .frozen
        spriteNode.run(.colorize(with: .clear, colorBlendFactor: 0.5, duration: 0.8))
    }
    
    func freed(){
        movmentSpeed = originalSpeed
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
    
    func checkHidingSpotsIntersections(_ scene: SKScene, _ hidingSpots: [HidingSpot]) -> HidingSpot? {
        scene.enumerateChildNodes(withName: "hidingSpot") { [self] (node, _) in
            let sprite = node as! SKSpriteNode
            if let spot = hidingSpots.first(where: {$0.spriteNode == sprite}){
                if spot.nodeReach!.intersects(nodeReach!) {
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
}
