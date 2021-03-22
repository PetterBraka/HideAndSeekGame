//
//  Help.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 23/02/2021.
//

import SpriteKit

class Help: SKScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentViewController:UIViewController = (UIApplication.shared.windows.first?.rootViewController!)!
        currentViewController.dismiss(animated: true, completion: nil)
    }
}
