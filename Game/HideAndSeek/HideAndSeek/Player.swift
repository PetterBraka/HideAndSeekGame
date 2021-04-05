//
//  Player.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 22/03/2021.
//

import UIKit
import SpriteKit

class Player: NSObject {
    enum Role: String {
        case hider = "Hider"
        case seeker = "Seeker"
    }

    enum Reach: Float {
        case short = 10
        case medium = 20
        case far = 30
    }
    
    enum Speed: CGFloat {
        case slow = 100
        case normal = 200
        case fast = 300
    }
    
    var reach: Reach
    var role: Role
    var movmentSpeed: Speed
    var spriteNode: SKSpriteNode
    var nodeReach: SKShapeNode?
    
    internal init(reach: Player.Reach, role: Player.Role, movmentSpeed: Speed) {
        self.reach = reach
        self.role = role
        self.movmentSpeed = movmentSpeed
        if role == Role.hider {
            self.spriteNode = SKSpriteNode(imageNamed: "Hider")
        } else {
            self.spriteNode = SKSpriteNode(imageNamed: "Seeker")
        }
    }
    
    func createSprite(size: CGSize, location: CGPoint) {
        var image = ""
        if role == Role.hider {
            image = "Hider"
        } else {
            image = "Seeker"
        }
        let player = SKSpriteNode(imageNamed: image)
        player.position = location
        player.zPosition = 1
        player.aspectFillToSize(size: size)
        player.name = "player"
        spriteNode = player
    }
    
    func drawReach(){
        let shape = SKShapeNode(circleOfRadius: CGFloat(reach.rawValue))
        shape.position = spriteNode.position
        shape.lineWidth = 2
        shape.strokeColor = .orange
        shape.zPosition = 99
        nodeReach = shape
    }
    
    func toString(){
        #if DEBUG
        print("-------------------------------")
        print("Role: \(role)")
        print("Reach: \(reach)")
        print("Speed: \(movmentSpeed)")
        print("Image: \(String(describing: spriteNode.texture))")
        print("-------------------------------")
        #endif
    }
}
