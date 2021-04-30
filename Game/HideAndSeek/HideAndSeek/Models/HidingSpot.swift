//
//  HidingSpot.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 21/03/2021.
//

import SpriteKit

class HidingSpot {
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
    var nodeReach: SKShapeNode!
    
    init(_ variant: Variant, _ location: CGPoint, capacity: Int) {
        self.type = variant
        self.image = variant.rawValue
        self.capacity = capacity
        self.location = location
        self.reachable = false
        createSprite()
    }
    
    init(_ variant: Variant, _ location: CGPoint, newTent: Bool, capacity: Int) {
        self.type = variant
        self.capacity = capacity
        self.location = location
        self.reachable = false
        switch variant {
        case .tent:
            if newTent {
                image = "tentNewStyle"
            } else {
                image = "tentOldStyle"
            }
        default:
            self.image = variant.rawValue
        }
        createSprite()
    }
    
    /**
     Will give the size needed for that type of hiding spot.
     
     - returns: A CGSize depening on the type.
     
     */
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
    
    /**
     Creates a SKSprite node for the hiding spot. I will aslo give it a SKPhysicsBody depending on the type of spot.
     
     - returns: A SKSpriteNode for the hiding spot.
     
     # Notes: #
     1. Should be called to get create any hiding spots.
     */
    private func createSprite() {
        let place = SKSpriteNode(imageNamed: image)
        place.position = location
        place.name = "hidingSpot"
        place.aspectFillToSize(size: getSize())
        place.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        place.zPosition = 1
        place.physicsBody = SKPhysicsBody(texture: place.texture!, size: place.size)
        place.physicsBody?.isDynamic = false
        place.physicsBody?.affectedByGravity = false
        place.physicsBody?.categoryBitMask = ColliderType.HidingPlace.rawValue
        spriteNode = place
        drawReach()
    }
    
    /**
     Will create a SKShapeNode of a circle with the radius of the spriteNode.
     
     # Notes: #
     1. Will be called after the SKSpriteNode has been created.
     */
    private func drawReach() {
        let shape = SKShapeNode(circleOfRadius: (spriteNode.size.width / 2))
        shape.position = CGPoint(
            x: spriteNode.position.x,
            y: spriteNode.position.y)
        shape.lineWidth = 2
        shape.strokeColor = .clear
        shape.zPosition = 99
        nodeReach = shape
    }
    
    /**
     Will print all the information from a hidingspot.
     
     # Notes: #
     1. Will print directly to the output.
     2. Will only print if in debug mode.
     */
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
