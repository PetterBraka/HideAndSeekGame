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
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    struct HelpItem {
        var image: String
        var secondImage: String?
        var explenation: String
    }
    
    //Creates and array of preset help options
    var helpItems = [HelpItem(image: "hider", explenation: "This is a hider. Your job as a hider is to hide from the seeker."),
                     HelpItem(image: "seeker", explenation: "This is a seeker. Your job as a seeker is to catch all other players."),
                     HelpItem(image: "tentNewStyle", explenation: "This is an hiding spot. You can hide here."),
                     HelpItem(image: "tentOldStyle", explenation: "This is an hiding spot. You can hide here."),
                     HelpItem(image: "house", explenation: "This is an hiding spot. You can hide here."),
                     HelpItem(image: "joystick_background",secondImage: "joystick" , explenation: "This is an joystick. You can use this to move around on the map."),
                     HelpItem(image: "button", explenation: "This is the action button. I will have a label stating the action yo can preform.")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This will add an cancel button in the nav bar.
        navBarItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(navBarTapped(sender:)))
        navBarItem.leftBarButtonItem?.tintColor = .systemRed
        tableview.delegate = self
        tableview.dataSource = self
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
        default:
            #if DEBUG
            print("unknown button pressed")
            #endif
        }
    }
}

// Here are the methodes needed to have a UITableView.
extension HelpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This sets the number of rows needed for each section.
        return helpItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // This will  create a cell.
        let cell = tableview.dequeueReusableCell(withIdentifier: "helpCell", for: indexPath) as! HelpCell
        cell.populate(helpItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // This sets the hight of the cell.
        return 125
    }
}
