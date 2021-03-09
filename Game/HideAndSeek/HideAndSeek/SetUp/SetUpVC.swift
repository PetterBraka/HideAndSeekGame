//
//  SetUpVC.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 24/02/2021.
//

import UIKit
import SpriteKit

class SetUpVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navBarItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(navBarTapped(sender:)))
        navBarItem.leftBarButtonItem?.tintColor = .systemRed
        navBarItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(navBarTapped(sender:)))
        // Do any additional setup after loading the view.
    }
    
    @objc func navBarTapped(sender: UIBarButtonItem){
        #if DEBUG
        print("Button tapped \(sender)")
        #endif
        switch sender {
        case navBarItem.leftBarButtonItem:
            #if DEBUG
            print("Cancel button pressed")
            #endif
            self.dismiss(animated: true, completion: nil)
        case navBarItem.rightBarButtonItem:
            #if DEBUG
            print("Done button pressed")
            #endif
            startGame()
        default:
            print("unknown button pressed")
        }
    }
    
    func startGame(){
        print("Game starting")
        let storyborad = UIStoryboard(name: "Main", bundle: nil)
        let gameScene = storyborad.instantiateViewController(withIdentifier :"GameSceneVC")
        self.present(gameScene, animated: true, completion: nil)
    }
    
}

extension SetUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetUpCell") as! SetUpCell
        cell.title.text = "Test data"
        cell.updateSegmentControler(["option 1", "option 2"])
        
        return cell
    }
    
    
}
