//
//  Bot.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 22/03/2021.
//

import SpriteKit

class Bot: Player {
    /**
     Will create a SKSpriteNode of a spesific size and set the locaiton for the sprite.
     
     - Parameters:
         - size: - A CGSize of the size the sprite should have.
         - location: - A CGPoint of where the sprite should be located.
     */
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
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = ColliderType.Player.rawValue
        player.physicsBody?.collisionBitMask = ColliderType.HidingPlace.rawValue
        spriteNode = player
        drawReach()
    }
    
    /**
     Will create a SKShapeNode of a circle with the radius of the sprite plus the reach the bot has.
     
     # Notes: #
     1. Should be called after the spriteNode has been created.
     */
    private func drawReach(){
        let raidus = (spriteNode.size.width / 2)
        let shape = SKShapeNode(circleOfRadius: raidus)
        shape.position = spriteNode.position
        shape.lineWidth = 2
        shape.strokeColor = .orange
        shape.zPosition = 99
        nodeReach = shape
    }
    
    func seek(for player: Player) {
        let position = player.spriteNode.position
        if player.movmentSpeed != .frozen {
            spriteNode.run(.move(to: position, duration: 2))
            if player.checkBotsIntersections([self]) != nil && !player.spriteNode.isHidden {
                if player.movmentSpeed != .frozen{
                    player.caught()
                }
            }
        } else {
            spriteNode.run(.stop())
        }
    }
}
