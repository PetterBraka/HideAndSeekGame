//
//  SetUpCell.swift
//  HideAndSeek
//
//  Created by Petter vang Brakalsvålet on 24/02/2021.
//

import UIKit

class SegmentCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateSegmentControler(_ options: [String]){
        segmentControl.removeAllSegments()
        for option in options {
            segmentControl.insertSegment(withTitle: option,
                                         at: segmentControl.numberOfSegments,
                                         animated: false)
        }
        segmentControl.selectedSegmentIndex = segmentControl.numberOfSegments / 3
    }
    
    func getData() -> String {
        let index = segmentControl.selectedSegmentIndex
        guard let segmentTitle = segmentControl.titleForSegment(at: index) else {
            return ""
        }
        return segmentTitle
    }

}
