//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Quoc Huy Ngo on 10/20/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import GoogleMaps
class DetailsViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!

    @IBOutlet weak var mapView: GMSMapView!
    var business:Business!
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        createMarker()
    }
    
    func setValue(){
        distanceLabel.text = business.distance
        reviewsLabel.text = String(format: "%d reviews", business.reviewCount!)
        categoryLabel.text = business.categories
        addressLabel.text = business.address
        nameLabel.text = business.name
        if business.imageURL != nil{
            restaurantImageView.setImageWith(business.imageURL!)
        }
        if business.ratingImageURL != nil{
            ratingImageView.setImageWith(business.ratingImageURL!)
        }
    }
}

extension DetailsViewController:GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let business = marker.userData as! Business
        let infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?.first! as! InfoWindow
        infoWindow.business = business
        return infoWindow
    }
    func createMarker(){
        mapView.clear()
        
        let camera = GMSCameraPosition.camera(withLatitude: (business.resLocation?.latitude!)!, longitude: (business.resLocation?.longitude!)!, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.userData = business
        marker.position = CLLocationCoordinate2DMake((business.resLocation?.latitude!)!, (business.resLocation?.longitude!)!)
        //marker.icon = createMarkerIcon(i + 1)
        marker.map = mapView
    }
}
