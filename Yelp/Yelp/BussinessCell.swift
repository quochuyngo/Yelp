//
//  BussinessCell.swift
//  Yelp
//
//  Created by Quoc Huy Ngo on 10/18/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking

class BussinessCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    var bussiness:Business!{
        didSet{
            if bussiness.imageURL != nil{
                 self.restaurantImageView.setImageWith(bussiness.imageURL!)
            }
            if bussiness.ratingImageURL != nil{
                self.ratingImageView.setImageWith(bussiness.ratingImageURL!)
            }
            
            self.nameLabel.text = bussiness.name
            self.distanceLabel.text = bussiness.distance
            self.addressLabel.text = bussiness.address
            self.categoryLabel.text = bussiness.categories
            self.reviewLabel.text = String(format:"%d reviews", bussiness.reviewCount!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
