//
//  Bot.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 22/03/2021.
//

import UIKit
import SpriteKit

class Bot: Player {
    override func createSprite(size: CGSize, location: CGPoint) {
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
        player.name = "bot"
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: image), size: size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = ColliderType.Bot
        spriteNode = player
    }
}
