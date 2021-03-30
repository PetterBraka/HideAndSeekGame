//
//  SetUpVC.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 24/02/2021.
//

import UIKit
import SpriteKit

class SetUpVC: UIViewController {
    struct GameOptions {
        var title: String
        var segments: Bool
        var options: [String]?
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    var gameOptions = [
        GameOptions(title: "Role", segments: true, options: ["Hider", "Seeker"]),
        GameOptions(title: "Difficulty", segments: true, options: [ChallangeRating.easy.rawValue,
                                                                   ChallangeRating.normal.rawValue,
                                                                   ChallangeRating.hard.rawValue]),
        GameOptions(title: "Duration", segments: false),
        GameOptions(title: "Number of players", segments: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
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
        gameOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if gameOptions[indexPath.row].segments{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentCell", for: indexPath) as! SegmentCell
            cell.title.text = gameOptions[indexPath.row].title
            cell.updateSegmentControler(gameOptions[indexPath.row].options!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as! StepperCell
            cell.title.text = gameOptions[indexPath.row].title
            return cell
        }
        
    }
    
    
}
