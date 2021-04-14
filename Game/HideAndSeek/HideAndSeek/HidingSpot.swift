//
//  HidingSpot.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 21/03/2021.
//

import UIKit
import SpriteKit

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
        place.physicsBody = SKPhysicsBody(texture: place.texture!, size: place.size)
        place.physicsBody?.isDynamic = false
        place.physicsBody?.affectedByGravity = false
        place.physicsBody?.categoryBitMask = ColliderType.HidingPlace
        return place
    }
    
    // Try replacing this with a node and check if the nodes are touching or not.
    // That might be lighter on the machin.
    func checkReach(_ player: Player) {
        let distance = abs(Float(hypot(player.spriteNode.position.x - location.x,
                                       player.spriteNode.position.y - location.y)))
        let nodeRadius = getSize().width / 2
        let range = player.reach.rawValue + Float(nodeRadius)
        if distance <= range {
            reachable = true
        } else {
            reachable = false
        }
    }
    
    func drawDebugArea(_ playerReach: Player.Reach) {
        let shape = SKShapeNode(circleOfRadius: (getSize().width / 2) + CGFloat(playerReach.rawValue))
        shape.position = CGPoint(
            x: spriteNode.position.x,
            y: spriteNode.position.y)
        shape.lineWidth = 2
        shape.strokeColor = .orange
        shape.zPosition = 99
        nodeReach = shape
    }
    
    func toString(){
        #if DEBUG
        print("-------------------------------")
        print("Type: \(type)")
        print("Capacity: \(capacity)")
        print("Image: \(String(describing: spriteNode.texture))")
        print("-------------------------------")
        #endif
    }
}
