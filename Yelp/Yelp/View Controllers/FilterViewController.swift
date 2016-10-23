//
//  FilterViewController.swift
//  Yelp
//
//  Created by Quoc Huy Ngo on 10/21/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol  FilterViewControllerDelegate {
    @objc optional func filterViewController(filterViewController:FilterViewController, didUpdateFilters filters:[String:AnyObject])
}
class FilterViewController: UIViewController {

    @IBOutlet weak var filterTableView: UITableView!
    //var filters:Filters!
    var isCollapse:Bool = true
    var indexRow:Int = 0
    var filters = Singleton.sharedInstance.getFilters()
    weak var delegate:FilterViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: AnyObject) {
        var parameters = [String:AnyObject]()
        for filter in filters{
            if filter.type == FilterType.switchControl{
                if filter.name == "Popular"{
                    if filter.options[0].selected == true{
                        parameters[filter.code] = true as AnyObject?
                    }
                }
                else{
                    var selectedItems = [String]()
                    for option in filter.options{
                        if option.selected == true {
                            selectedItems.append(option.value)
                        }
                    }
                    if selectedItems.count > 0{
                        parameters[filter.code] = selectedItems as AnyObject?
                    }
                }
            }
            else{
                for option in filter.options{
                    if option.selected == true{
                        parameters[filter.code] = option.value as AnyObject?
                    }
                }
                
            }
        }
        if parameters.count > 0 {
           delegate?.filterViewController!(filterViewController: self, didUpdateFilters: parameters)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters[section].options.count
        //return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = filters[indexPath.section] as Filter
        switch filter.type!{
        case .switchControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
            cell.delegate = self
            cell.categoryNameLabel.text = filter.options[indexPath.row].name
            cell.onSwitch.isOn = filter.options[indexPath.row].selected
            return cell
        case .menuContextControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuContextCell") as! MenuContextCell
            cell.distanceLabel.text = filter.options[indexPath.row].name
            let isSelected =  filter.options[indexPath.row].selected
            cell.stateImageView.image = setImage(selected:isSelected!, isCollapse: isCollapse)
            //cell.distanceLabel.isHidden = true
            //cell.stateImageView.isHidden = true
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = filters[section]
        return filter.name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let filter = filters[indexPath.section]
        if filter.type == FilterType.menuContextControl{
            if isCollapse{
                if !filter.options[indexPath.row].selected{
                    return 0
                }
            }
        }
        return 35.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.section]
        if filter.type == FilterType.menuContextControl{
            if isCollapse{
                self.isCollapse = false
                /*for option in filter.options{
                    option.selected = true
                }*/
            }
            else{
                self.isCollapse = true
                for option in filter.options{
                    option.selected = false
                }
                filter.options[indexPath.row].selected = true
            }
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        }
    }
    func setImage(selected:Bool, isCollapse:Bool)->UIImage{
        
        if !isCollapse{
            if selected{
                return UIImage(named: "check")!
            }
            else{
                return UIImage(named: "uncheck")!

            }
                    }
        else{
            if selected{
                 return UIImage(named: "arrow_down")!
            }
            else{
                return UIImage(named: "uncheck")!
            }
            
        }
       
    }
}

extension FilterViewController: CategoryCellDelegate{
    func categoryCell(categoryCell: CategoryCell, didValueChange value: Bool) {
        let indexPath = filterTableView.indexPath(for: categoryCell)
        filters[(indexPath?.section)!].options[(indexPath?.row)!].selected = value
    }
}
