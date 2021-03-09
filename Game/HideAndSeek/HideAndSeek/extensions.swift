//
//  extensions.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 26/02/2021.
//

import SpriteKit

extension SKSpriteNode {
    func aspectFillToSize(size: CGSize) {
        guard let texture = self.texture else {
            print("Can't set aspect ratio of node. No textures found for node")
            return
        }
        self.size = texture.size()
        let heightRatio = size.height / texture.size().height
        let widthRatio = size.width / texture.size().width
        
        let scaleingRatio = widthRatio > heightRatio ? widthRatio : heightRatio
        
        setScale(scaleingRatio)
    }
}
