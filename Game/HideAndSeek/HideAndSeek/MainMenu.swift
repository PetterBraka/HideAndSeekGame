//
//  MainMenu.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 22/02/2021.
//

import SpriteKit

class MainMenu: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         for touch in touches {
              let location = touch.location(in: self)
              let touchedNode = atPoint(location)
              if touchedNode.name == "HelloButton" {
                   // Call the function here.
              }
         }
    }
}
