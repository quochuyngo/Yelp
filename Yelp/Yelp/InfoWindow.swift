//
//  InfoWindow.swift
//  Yelp
//
//  Created by Quoc Huy Ngo on 10/20/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import AFNetworking

class InfoWindow: UIView {
    

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var business:Business!{
        didSet{
            self.nameLabel.text = business.name
            self.addressLabel.text = business.address
            self.reviewsLabel.text = String(format:"%d reviews",business.reviewCount!)
            self.distanceLabel.text = business.distance
            self.ratingImageView.setImageWith(business.ratingImageURL!)
            self.restaurantImageView.setImageWith(business.imageURL!)
        }
    }
}
