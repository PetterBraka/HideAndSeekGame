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
    
    /**
     Will set segments for the segment controller, and select the default values.
     
     - parameter options: - An array of string that will be set to the segment controller.
     */
    func updateSegmentControler(_ options: [String]){
        segmentControl.removeAllSegments()
        for option in options {
            segmentControl.insertSegment(withTitle: option,
                                         at: segmentControl.numberOfSegments,
                                         animated: false)
        }
        segmentControl.selectedSegmentIndex = segmentControl.numberOfSegments / 3
    }
    
    /**
     Will get the title of the selected item in a UISegmentControl
     
     - returns: The string selected by the player.
     */
    func getTitleOfSelectedSegment() -> String {
        let index = segmentControl.selectedSegmentIndex
        guard let segmentTitle = segmentControl.titleForSegment(at: index) else {
            return ""
        }
        return segmentTitle
    }

}
