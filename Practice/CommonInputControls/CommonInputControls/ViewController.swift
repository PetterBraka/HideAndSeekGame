//
//  ViewController.swift
//  CommonInputControls
//
//  Created by Petter vang Brakalsvålet on 27/01/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Button tapped")
    }
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn{
            print("switch is on")
        } else {
            print("switch is off")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

