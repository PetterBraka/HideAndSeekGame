//
//  SetUpVC.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 24/02/2021.
//

import UIKit

class SetUpVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    struct GameOptions {
        var title: String
        var hasSegments: Bool
        var options: [String]?
    }
    var gameOptions = [
        GameOptions(title: "Role", hasSegments: true,
                    options: [Player.Role.hider.rawValue, Player.Role.seeker.rawValue]),
        GameOptions(title: "Difficulty", hasSegments: true, options: [ChallangeRating.easy.rawValue,
                                                                      ChallangeRating.normal.rawValue,
                                                                      ChallangeRating.hard.rawValue]),
        GameOptions(title: "Speed", hasSegments: true, options: ["Slow", "Normal", "Fast"]),
        GameOptions(title: "Reach", hasSegments: true, options: ["Short", "Medium", "Far"]),
        GameOptions(title: "Duration", hasSegments: false),
        GameOptions(title: "Bots", hasSegments: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        // Setts up navigation bar items for cancel and done.
        navBarItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(navBarTapped(sender:)))
        navBarItem.leftBarButtonItem?.tintColor = .systemRed
        navBarItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(navBarTapped(sender:)))
    }
    
    /**
     Will handle the button click from a navigation bat item.
     
     - parameter sender: - The UIBarButtonItem that called this function.
     
     # Example #
     ```
     navBarItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(navBarTapped(sender:)))
     ```
     */
    @objc func navBarTapped(sender: UIBarButtonItem){
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
    
    /**
     Will get and unwrap the title for a segmentCell.
     
     - parameter indexPath: - The IndexPath for the SegmentCell you want the title for.
     - returns: A string of the cells title.
     */
    private func getSegmentCellTitle(indexPath: IndexPath) -> String{
        let cell = tableView.cellForRow(at: indexPath) as! SegmentCell
        return cell.title.text ?? ""
    }
    
    
    /**
     Will return the role selected by the player.
     
     - returns: A Player.Role that was set by the player.
     */
    private func getRole() -> Player.Role {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SegmentCell
        switch cell.getTitleOfSelectedSegment(){
        case Player.Role.seeker.rawValue:
            return .seeker
        default:
            return .hider
        }
    }
    
    
    /**
     Will return the difficulty selected by the player.
     
     - returns: A ChallangeRating that was set by the player
     */
    private func getDifficulty() -> ChallangeRating{
        switch getSegmentCellTitle(indexPath: IndexPath(row: 1, section: 0)) {
            case ChallangeRating.easy.rawValue:
                return .easy
            case ChallangeRating.normal.rawValue:
                return .normal
            case ChallangeRating.hard.rawValue:
                return .hard
            default:
                return .normal
            }
    }
    
    
    /**
     Will return the speed selecteed by the player.
     
     - returns: Player.Speed that was set by the player.
     */
    private func getSpeed() -> Player.Speed {
        switch getSegmentCellTitle(indexPath: IndexPath(row: 2, section: 0)) {
        case "Slow":
            return .slow
        case "Normal":
            return .normal
        case "Fast":
            return .fast
        default:
            return .normal
        }
    }
    
    
    /**
     Will return the reach selected by the player.
     
     - returns: Player.Reach that was set by the player.
     */
    private func getReach() -> Player.Reach {
        switch getSegmentCellTitle(indexPath: IndexPath(row: 3, section: 0)) {
        case "Short":
            return .short
        case "Medium":
            return .medium
        case "Far":
            return .far
        default:
            return .medium
        }
    }
    
    /**
     Will return the duration set by the player.
     
     - returns: An Int selected by the player as the duration for the game.
     */
    private func getDuration() -> Int {
        let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! StepperCell
        return Int(cell.stepper.value)
    }
    
    /**
     Will return the nuber of bots set by the player.
     
     - returns: An Int selected by the player as the number of bots in the game.
     */
    private func getNumberOfBots() -> Int {
        let cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! StepperCell
        return Int(cell.stepper.value)
    }
    
    
    /**
     Will create a segua from the SetUpVC to the GameSceneVC
     */
    private func startGame(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameScene = storyboard.instantiateViewController(withIdentifier: "GameSceneVC") as! GameSceneVC
        // This sets the values the player has selected.
        gameScene.player = Player(reach: getReach(), role: getRole(), movmentSpeed: getSpeed())
        gameScene.numberOfBots = getNumberOfBots()
        gameScene.gameDifficulty = getDifficulty()
        gameScene.duration = getDuration()
        gameScene.modalPresentationStyle = .fullScreen
        self.present(gameScene, animated: true, completion: nil)
    }
}

// Here are the methodes needed to have a UITableView.
extension SetUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This sets the number of rows needed for each section.
        return gameOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // This will create a cell and check what type of cell should be created.
        if gameOptions[indexPath.row].hasSegments{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentCell", for: indexPath) as! SegmentCell
            cell.title.text = gameOptions[indexPath.row].title
            cell.updateSegmentControler(gameOptions[indexPath.row].options!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as! StepperCell
            cell.title.text = gameOptions[indexPath.row].title
            if gameOptions[indexPath.row].title == "Duration" {
                cell.stepper.value = 30
                cell.stepper.minimumValue = 30
                cell.stepper.maximumValue = 360
                cell.stepper.stepValue = 15
                cell.steppNumber.text = "\(Int(cell.stepper.value))"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // This sets the hight of the cell.
        return 44
    }
}
