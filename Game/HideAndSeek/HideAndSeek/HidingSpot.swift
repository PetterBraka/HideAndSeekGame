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
