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
    @IBAction func stepperAction(_ sender: UIStepper) {
        steppNumber.text = Int(sender.value).description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
