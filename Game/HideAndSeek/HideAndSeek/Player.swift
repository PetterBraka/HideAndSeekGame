//
//  Player.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 22/03/2021.
//

import UIKit
import SpriteKit

class Player: NSObject {
    enum Role {
        case hider
        case seeker
    }

    enum Reach: Float {
        case short = 10
        case medium = 20
        case far = 30
    }
    
    var reach: Reach
    var role: Role
    var movmentSpeed: CGFloat = 200
    var spriteNode: SKSpriteNode
    
    internal init(reach: Player.Reach, role: Player.Role, movmentSpeed: CGFloat, image: String) {
        self.reach = reach
        self.role = role
        self.movmentSpeed = movmentSpeed
        self.spriteNode = SKSpriteNode(imageNamed: image)
    }
    
    func createSprite(size: CGSize, location: CGPoint) {
        let player = SKSpriteNode(imageNamed: "player")
        player.position = location
        player.zPosition = 1
        player.aspectFillToSize(size: size)
        player.name = "player"
        spriteNode = player
    }
}
