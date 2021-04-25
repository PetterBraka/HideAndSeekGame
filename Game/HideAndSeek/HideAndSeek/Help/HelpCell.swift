//
//  HelpCell.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 22/04/2021.
//

import UIKit

class HelpCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIButton!
    @IBOutlet weak var label: UILabel!
    
    // This will populate the cell with the data passed.
    func populate(_ item: HelpVC.HelpItems) {
        cellImage.setBackgroundImage(UIImage(named: item.image), for:.normal)
        label.text = item.explenation
        // Checks if a second image is passed, and if not it will set a blank image as the image.
        guard let secondImage = item.secondImage else {
            cellImage.setImage( .none, for: .normal)
            return
        }
        cellImage.setImage(UIImage(named: secondImage), for: .normal)
    }
}
