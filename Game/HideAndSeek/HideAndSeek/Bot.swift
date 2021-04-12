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
        spriteNode = player
    }
}
