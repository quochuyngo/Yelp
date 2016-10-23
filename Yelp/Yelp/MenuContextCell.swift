//
//  MenuContextCell.swift
//  Yelp
//
//  Created by Quoc Huy Ngo on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
@objc protocol MenuContextCellDelegate {
    @objc optional func selectCell(dropDownCell: MenuContextCell, didSelect currentImg: UIImage)
}
class MenuContextCell: UITableViewCell {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    
    var delegate:MenuContextCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if delegate != nil{
            delegate.selectCell!(dropDownCell: self, didSelect: stateImageView.image!)
        }
        // Configure the view for the selected state
    }

}
