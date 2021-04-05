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
    private struct GameOptions {
        var title: String
        var hasSegments: Bool
        var options: [String]?
    }
    private var gameOptions = [
        GameOptions(title: "Role", hasSegments: true,
                    options: [Player.Role.hider.rawValue, Player.Role.seeker.rawValue]),
        GameOptions(title: "Difficulty", hasSegments: true, options: [ChallangeRating.easy.rawValue,
                                                                      ChallangeRating.normal.rawValue,
                                                                      ChallangeRating.hard.rawValue]),
        GameOptions(title: "Speed", hasSegments: true, options: ["Slow", "Normal", "Fast"]),
        GameOptions(title: "Reach", hasSegments: true, options: ["Short", "Medium", "Far"]),
        GameOptions(title: "Duration", hasSegments: false),
        GameOptions(title: "Bots", hasSegments: false)]
    var difficulty = ChallangeRating.normal
    var playersRole = Player.Role.hider
    var playerReach = Player.Reach.medium
    var numberOfPlayer = 2
    var duration = 2
    var movementSpeed = Player.Speed.normal
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        navBarItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(navBarTapped(sender:)))
        navBarItem.leftBarButtonItem?.tintColor = .systemRed
        navBarItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(navBarTapped(sender:)))
    }
    
    @objc func navBarTapped(sender: UIBarButtonItem){
        grabData()
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
            #if DEBUG
            print("unknown button pressed")
            #endif
        }
    }
    
    func grabData() {
        for row in 0...gameOptions.count - 1{
            if gameOptions[row].hasSegments {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SegmentCell
                let segmentTitle = cell.getData()
                switch gameOptions[row].title {
                case "Role": // Role
                    if Player.Role.hider.rawValue == segmentTitle {
                        playersRole = Player.Role.hider
                    } else {
                        playersRole = Player.Role.seeker
                    }
                case "Difficulty": //Difficulty
                    switch segmentTitle {
                    case ChallangeRating.easy.rawValue:
                        difficulty = .easy
                    case ChallangeRating.normal.rawValue:
                        difficulty = .normal
                    case ChallangeRating.hard.rawValue:
                        difficulty = .hard
                    default:
                        difficulty = .normal
                    }
                case "Reach": // Reach
                    switch segmentTitle {
                    case "Short":
                        playerReach = .short
                    case "Medium":
                        playerReach = .medium
                    case "Far":
                        playerReach = .far
                    default:
                        playerReach = .medium
                    }
                case "Speed": // Speed
                    switch segmentTitle {
                    case "Slow":
                        movementSpeed = Player.Speed.slow
                    case "Normal":
                        movementSpeed = Player.Speed.normal
                    case "Fast":
                        movementSpeed = Player.Speed.fast
                    default:
                        movementSpeed = Player.Speed.normal
                    }
                default:
                    #if DEBUG
                    print("can't find option")
                    #endif
                }
            } else {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! StepperCell
                switch gameOptions[row].title {
                case "Duration": // Duration
                    duration = Int(cell.stepper.value)
                case "Bots": // Bots
                    numberOfPlayer = Int(cell.stepper.value)
                default:
                    #if DEBUG
                    print("can't find option")
                    #endif
                }
            }
        }
    }
    
    func startGame(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameScene = storyboard.instantiateViewController(withIdentifier: "GameSceneVC") as! GameSceneVC
        gameScene.player = Player(reach: playerReach, role: playersRole, movmentSpeed: movementSpeed, image: "player")
        gameScene.numberOfPlayers = numberOfPlayer
        gameScene.gameDifficulty = difficulty
        gameScene.duration = duration
        self.present(gameScene, animated: true, completion: nil)
    }
    
}

extension SetUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if gameOptions[indexPath.row].hasSegments{
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
