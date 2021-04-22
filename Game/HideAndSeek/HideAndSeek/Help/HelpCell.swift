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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(_ item: HelpVC.HelpItems) {
        cellImage.setBackgroundImage(UIImage(named: item.image), for:.normal)
        if item.secondImage != nil{
            cellImage.setImage(UIImage(named: item.secondImage!), for: .normal)
        } else {
            cellImage.setImage( .none, for: .normal)
        }
        label.text = item.explenation
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
