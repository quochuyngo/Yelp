//
//  CategoryCell.swift
//  Yelp
//
//  Created by Quoc Huy Ngo on 10/21/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol CategoryCellDelegate {
    @objc optional func categoryCell(categoryCell:CategoryCell, didValueChange value:Bool)
}
class CategoryCell: UITableViewCell {

    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var categoryNameLabel: UILabel!

    weak var delegate:CategoryCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchValueChanged(_ sender: AnyObject) {
        self.delegate?.categoryCell!(categoryCell: self, didValueChange: onSwitch.isOn)
    }
}
