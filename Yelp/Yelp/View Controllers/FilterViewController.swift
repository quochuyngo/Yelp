//
//  FilterViewController.swift
//  Yelp
//
//  Created by Quoc Huy Ngo on 10/21/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol  FilterViewControllerDelegate {
    @objc optional func filterViewController(filterViewController:FilterViewController, didUpdateFilters filters:[String])
}
class FilterViewController: UIViewController {

    @IBOutlet weak var filterTableView: UITableView!
    var categories:[[String:String]]!
    var switchesState:[Int:Bool]!
    var filters:Filters!
    weak var delegate:FilterViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories = Category.getCategories()
        self.switchesState = [Int:Bool]()
        self.filters = Filters()
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        var filters:[String] = [String]()
        for (row, selected) in switchesState{
            if selected{
                filters.append(categories[row]["code"]!)
            }
        }
        if filters.count > 0 {
           delegate?.filterViewController!(filterViewController: self, didUpdateFilters: filters)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.filters[section].options.count
        //return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = filters.filters[indexPath.section] as Filter
        switch filter.type!{
        case .switchControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
            cell.delegate = self
            cell.categoryNameLabel.text = filter.options[indexPath.row].name
            cell.onSwitch.isOn = false
            return cell
        case .menuContextControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuContextCell") as! MenuContextCell
            cell.distanceLabel.text = filter.options[indexPath.row].name
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        cell.delegate = self
        cell.categoryNameLabel.text = categories[indexPath.row]["name"]
        cell.onSwitch.isOn = switchesState[indexPath.row] ?? false
        return cell*/
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = filters.filters[section]
        return filter.name
    }
}

extension FilterViewController: CategoryCellDelegate{
    func categoryCell(categoryCell: CategoryCell, didValueChange value: Bool) {
        let index = filterTableView.indexPath(for: categoryCell)?.row
        switchesState[index!] = value
    }
}
