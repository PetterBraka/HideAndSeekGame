//
//  StepperCell.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 30/03/2021.
//

import UIKit

class StepperCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var steppNumber: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    // This will update the label with the value of the stepper.
    @IBAction func stepperAction(_ sender: UIStepper) {
        steppNumber.text = Int(sender.value).description
    }
}
