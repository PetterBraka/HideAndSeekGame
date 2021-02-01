//
//  ViewController.swift
//  GettingStarted
//
//  Created by Petter vang Brakalsvålet on 22/01/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    
    @IBAction func changeTitle(_ sender: Any) {
        if overrideUserInterfaceStyle == .light {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

