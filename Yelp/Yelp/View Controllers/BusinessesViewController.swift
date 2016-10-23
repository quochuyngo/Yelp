//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Edited by Quoc Huy Ngo
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit
import MBProgressHUD
import GoogleMaps

class BusinessesViewController: UIViewController {
    var businesses: [Business]!
    var searchBar:UISearchBar!
    var isMoreLoadingData:Bool = false
    var isNavigateDetailsView:Bool = false
    var indicatorLoading:UIActivityIndicatorView!
    var currentSearchKey:String!
    var currentBusiness:Business!
    @IBOutlet weak var restaurantTableView: UITableView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultLabel.isHidden = true
        //set search bar
        self.businesses = [Business]()
        self.searchBar = createSearchBar()
        self.searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        //set row height dynamic
        self.restaurantTableView.rowHeight = UITableViewAutomaticDimension
        self.restaurantTableView.estimatedRowHeight = 100
        
        self.restaurantTableView.dataSource = self
        self.restaurantTableView.delegate = self
        
        self.mapView.delegate = self
        self.mapView.isHidden = true
        
        self.createIndicatorLoading()
        
        //default search
        search(keyword: "restaurant")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isNavigateDetailsView = false
    }
    
    @IBAction func onMapButtonTapped(_ sender: AnyObject) {
        if mapView.isHidden{
            mapView.isHidden = false
            restaurantTableView.isHidden = true
            mapButton.image = UIImage(named: "list")
        }
        else{
            mapView.isHidden = true
            restaurantTableView.isHidden = false
            mapButton.image = UIImage(named: "map")

        }
    }
    @IBAction func onTapScreen(_ sender: AnyObject) {
        self.searchBar.endEditing(true)
    }

    func createSearchBar()->UISearchBar{
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        return searchBar
    }
    
    func setLabelNotice(ishidden:Bool, message:String){
        if !ishidden{
            self.resultLabel.text = message
            self.resultLabel.isHidden = ishidden
            self.restaurantTableView.isHidden = true
            self.mapView.isHidden = true
        }
        else{
            self.resultLabel.isHidden = ishidden
            self.restaurantTableView.isHidden = false
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isNavigateDetailsView{
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.business = currentBusiness
        }
        else{
            let navVC = segue.destination as! UINavigationController
            let filterVC = navVC.topViewController as! FilterViewController
            filterVC.delegate = self
        }
    }
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            return businesses.count
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BussinessCell") as! BussinessCell
        cell.bussiness = businesses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        isNavigateDetailsView = true
        currentBusiness = businesses[indexPath.row]
        return indexPath
    }
    
    func createIndicatorLoading(){
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: restaurantTableView.superview!.frame.width, height: 50))
        self.indicatorLoading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.indicatorLoading.center = footerView.center
        self.indicatorLoading.isHidden = true
        footerView.addSubview(self.indicatorLoading)
        self.restaurantTableView.tableFooterView = footerView
    }
}

extension BusinessesViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.clearResults()
        search(keyword: searchBar.text!)
       
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
    }
    
    func search(keyword:String, offset:Int = 0){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        setLabelNotice(ishidden: false, message: "")
        getData(keyword: keyword, offset: offset)
        

    }
    func clearResults(){
        self.businesses = [Business]()
    }
    
    func getData(keyword:String, offset:Int, categories:[String]? = nil, sort:String? = nil, deals:Bool? = false , distance:String? = nil){
        if isMoreLoadingData{
            self.indicatorLoading.isHidden = false
            self.indicatorLoading.startAnimating()
        }
        
        Business.search(with: keyword, offset: offset, limit: 20, sort: nil, categories: categories, deals: nil){
            (businesses: [Business]?, total:Int? ,error: Error?) in
            if let businesses = businesses {
               
                if !self.isMoreLoadingData{
                    self.businesses = businesses
                    if businesses.count == 0{
                        self.setLabelNotice(ishidden: false, message: "No result!")
                    }
                    else{
                        self.restaurantTableView.reloadData()
                        self.setLabelNotice(ishidden: true, message: "")
                        let top = NSIndexPath(row: 0, section: 0)
                        self.restaurantTableView.scrollToRow(at: top as IndexPath, at: .top, animated: true)
                    }

                }
                else{
                    if self.businesses != nil{
                        self.businesses.append(contentsOf: businesses)
                    }
                    
                    self.indicatorLoading.isHidden = true
                    self.indicatorLoading.stopAnimating()
                }
                self.restaurantTableView.reloadData()
                self.isMoreLoadingData = false
                self.createMarkers()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}

//load infinity
extension BusinessesViewController:UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreLoadingData{
            //calculate
            let scrollViewContentHeight = restaurantTableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - restaurantTableView.bounds.size.height
            if scrollView.contentOffset.y > scrollViewOffsetThreshold && restaurantTableView.isDragging{
                isMoreLoadingData = true
                getData(keyword: searchBar.text!, offset: businesses.count, categories: nil)
            }
        }
    }
}

extension BusinessesViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let business = marker.userData as! Business
        let infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?.first! as! InfoWindow
        infoWindow.business = business
        return infoWindow
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.isNavigateDetailsView = true
        self.currentBusiness = marker.userData as! Business
        self.performSegue(withIdentifier: "SegueDetails", sender: self)
    }
    func createMarkers(){
        mapView.clear()
        
        if businesses.count > 0 {
            let camera = GMSCameraPosition.camera(withLatitude: (businesses[0].resLocation?.latitude!)!, longitude: (businesses[0].resLocation?.longitude!)!, zoom: 15)
            mapView.camera = camera
            mapView.isMyLocationEnabled = true
            
            // Create maker for each business
            for business in businesses {
                let marker = GMSMarker()
                marker.userData = business
                marker.position = CLLocationCoordinate2DMake((business.resLocation?.latitude!)!, (business.resLocation?.longitude!)!)
                marker.map = mapView
            }
        }

    }
}

extension BusinessesViewController : FilterViewControllerDelegate{
    func filterViewController(filterViewController: FilterViewController, didUpdateFilters filters: [String:AnyObject]) {
        var deals:Bool = false
        if let value = filters["deals_filter"]{
            deals = value as! Bool
        }
        
        var categories:[String]? = nil
        if let value = filters["category_filter"]{
            categories = (value as? [String])!
         }
         
        var distance:String = ""
        if let value = filters["radius_filter"]{
            distance = (value as? String)!
         }
        var sortBy:String = ""
        if let value = filters["sort"]{
            sortBy = (value as? String)!
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        getData(keyword: searchBar.text!, offset: 0, categories: categories, sort:sortBy, deals:deals, distance: distance)
    }
}
