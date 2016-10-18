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

class BusinessesViewController: UIViewController {
    var businesses: [Business]!
    var searchBar:UISearchBar!
    var isMoreLoadingData:Bool = false
    @IBOutlet weak var restaurantTableView: UITableView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
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
        
        //default search
        search(keyword: "restaurant")
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
        }
        else{
            self.resultLabel.isHidden = ishidden
            self.restaurantTableView.isHidden = false
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
        loadData(keyword: keyword)
        

    }
    func clearResults(){
        self.businesses = [Business]()
    }
    
    func loadData(keyword:String){
        Business.search(with: keyword, offset: 0, limit: 20) { (businesses: [Business]?, total:Int? ,error: Error?) in
            if let businesses = businesses {
                self.businesses = businesses
                
                self.restaurantTableView.reloadData()
                self.isMoreLoadingData = false
                if businesses.count == 0{
                    self.setLabelNotice(ishidden: false, message: "No result!")
                }
                else{
                    self.setLabelNotice(ishidden: true, message: "")
                    let top = NSIndexPath(row: 0, section: 0)
                    self.restaurantTableView.scrollToRow(at: top as IndexPath, at: .top, animated: true)
                }
            
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func loadMoreData(keyword:String, offset:Int){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.search(with: keyword, offset: offset, limit: 20) { (businesses: [Business]?, total:Int? ,error: Error?) in
            if let businesses = businesses {
                if self.businesses != nil{
                    self.businesses.append(contentsOf: businesses)
                }
                else{
                    self.businesses = businesses
                }
                self.restaurantTableView.reloadData()
                self.isMoreLoadingData = false
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
                loadMoreData(keyword: searchBar.text!, offset: businesses.count)
            }
        }
    }
}
