//
//  HelpVC.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 15/03/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class HelpVC: UIViewController {
    @IBOutlet weak var navBarItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(navBarTapped(sender:)))
        navBarItem.leftBarButtonItem?.tintColor = .systemRed
    }
    
    @objc func navBarTapped(sender: UIBarButtonItem){
        switch sender {
        case navBarItem.leftBarButtonItem:
            #if DEBUG
            print("Cancel button pressed")
            #endif
            self.dismiss(animated: true, completion: nil)
        default:
            #if DEBUG
            print("unknown button pressed")
            #endif
        }
    }
}
