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
    
    private let zPosition: CGFloat = 2
    private var size: CGSize
    
    let type: Variant
    let location: CGPoint
    let capacity: Int?
    
    var spriteNode: SKSpriteNode = SKSpriteNode()
    var image: String
    var reachable: Bool
    
    init(_ variant: Variant, _ location: CGPoint, image: String, capacity: Int?) {
        self.type = variant
        self.location = location
        self.image = image
        self.reachable = false
        self.capacity = capacity
        self.size = CGSize(width: 20, height: 20)
        super.init()
//        Warning - Check if this will work (Will it run the function getSize()?)
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
        place.name = type.rawValue
        place.aspectFillToSize(size: size)
        place.zPosition = zPosition
        return place
    }
    
    func checkReach(_ player: Player) {
        let distance = abs(Float(hypot(player.spriteNode.position.x - location.x,
                                       player.spriteNode.position.y - location.y)))
        let nodeRadius = abs(Float(hypot(size.width / 2, size.height / 2)))
        let range = player.reach.rawValue + nodeRadius
        if distance <= range {
            reachable = true
        } else {
            reachable = false
        }
    }
}
