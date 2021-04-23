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
    
    struct HelpItems {
        var image: String
        var secondImage: String?
        var explenation: String
    }
    
    var helpItems = [HelpItems(image: "Hider", explenation: "This is a hider. Your job as a hider is to hide from the seeker."),
                     HelpItems(image: "Seeker", explenation: "This is a seeker. Your job as a seeker is to catch all other players"),
                     HelpItems(image: "tentNew", explenation: "This is an hiding spot. You can hide here"),
                     HelpItems(image: "tentOld", explenation: "This is an hiding spot. You can hide here"),
                     HelpItems(image: "house", explenation: "This is an hiding spot. You can hide here"),
                     HelpItems(image: "joystick_background",secondImage: "joystick" , explenation: "This is an joystick. You can use this to move around on the map")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(navBarTapped(sender:)))
        navBarItem.leftBarButtonItem?.tintColor = .systemRed
        tableview.delegate = self
        tableview.dataSource = self
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

extension HelpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        helpItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "helpCell", for: indexPath) as! HelpCell
        cell.populate(helpItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
