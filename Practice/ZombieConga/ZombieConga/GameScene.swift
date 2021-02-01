//
//  GameScene.swift
//  ZombieConga
//
//  Created by Petter vang Brakalsvålet on 01/02/2021.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView){
        backgroundColor = SKColor.black
        let background = SKSpriteNode(imageNamed: "background")
        addChild(background)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.scale(to: CGSize(width: 2048 * 2.4, height: 640 * 2.4))
        background.anchorPoint = .init(x: 0.5, y: 0.5) // Default anchor
//        background.zRotation = CGFloat.pi / 8
        let mySize = background.size
        print("Size: \(mySize)")
    }
}
