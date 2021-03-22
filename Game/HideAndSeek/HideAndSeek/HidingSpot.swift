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
    private var size: CGSize = CGSize(width: 20, height: 20)
    
    let type: Variant
    let location: CGPoint
    let capacity: Int?
    
    var spriteNode: SKSpriteNode = SKSpriteNode()
    var image: String
    var avalible: Bool?
    
    init(_ variant: Variant, _ location: CGPoint, _ capacity: Int?, image: String, avalible: Bool?) {
        self.type = variant
        self.location = location
        self.image = image
        self.avalible = avalible
        self.capacity = capacity
        super.init()
//        Warning - Check if this will work (Will it run the function getSize()?)
        self.size = getSize()
        self.spriteNode = createSprite()
    }
    
    private func getSize() -> CGSize {
        switch type {
        case .mountan:
            return CGSize(width: 100, height: 400)
        case .house:
            return CGSize(width: 125, height: 125)
        case .tent:
            return CGSize(width: 40, height: 40)
        case .tree:
            return CGSize(width: 30, height: 60)
        case .lake:
            return CGSize(width: 200, height: 75)
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
    
}
