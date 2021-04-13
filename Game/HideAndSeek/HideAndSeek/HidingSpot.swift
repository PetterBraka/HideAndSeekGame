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
        case mountan = "mountan"
        case house = "house"
        case tent = "tent"
        case tree = "tree"
        case lake = "lake"
    }
    
    private let zPosition: CGFloat = 1
    private var size: CGSize
    
    let type: Variant
    let location: CGPoint
    let capacity: Int?
    
    var spriteNode: SKSpriteNode = SKSpriteNode()
    var image: String
    var reachable: Bool
    var nodeReach: SKShapeNode?
    
    init(_ variant: Variant, _ location: CGPoint, image: String, capacity: Int?) {
        self.type = variant
        self.location = location
        self.image = image
        self.reachable = false
        self.capacity = capacity
        self.size = CGSize(width: 20, height: 20)
        super.init()
        self.size = getSize()
        self.spriteNode = createSprite()
    }
    
    private func getSize() -> CGSize {
        switch type {
        case .mountan:
            return CGSize(width: 200, height: 800)
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
        place.aspectFillToSize(size: size)
        place.zPosition = zPosition
        place.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: image), size: size)
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
        let nodeRadius = size.width / 2
        let range = player.reach.rawValue + Float(nodeRadius)
        if distance <= range {
            reachable = true
        } else {
            reachable = false
        }
    }
    
    func drawDebugArea(_ playerReach: Player.Reach) {
        let shape = SKShapeNode(circleOfRadius: (size.width / 2) + CGFloat(playerReach.rawValue))
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
        print("Capacity: \(capacity ?? 0)")
        print("Image: \(String(describing: spriteNode.texture))")
        print("-------------------------------")
        #endif
    }
}
