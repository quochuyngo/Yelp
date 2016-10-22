//
//  Filters.swift
//  Yelp
//
//  Created by Quoc Huy Ngo on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class Filters{
    var filters = [
        
        Filter(name: "Popular",
               options: [
                Option(name: "Offering a deal", code: "deals_filter", value: "1")],
               type: FilterType.switchControl),
        
        Filter(name: "Sort by", code: "sort",
               options: [Option(name: "Best Matched", value: "0"),
                         Option(name: "Distance", value: "1"),
                         Option(name: "Rating", value: "2")],
               type: FilterType.menuContextControl),
        Filter(name: "Distance", code: "radius_filter",
               options: [Option(name: "Auto", value: ""),
                         Option(name: "1 mile", value: "1"),
                         Option(name:"2 miles", value: "2"),
                         Option(name:"5 miles", value: "5")],
               type: FilterType.menuContextControl),
        Filter(name: "Category", code: "category_filter",
               options: Filters.getCategories(),
            type: FilterType.switchControl)
    ]
    
    static func getCategories()->[Option]{
        var options = [Option]()
        for category in Category.getCategories(){
            let option = Option(name: category["name"], value: category["code"])
            options.append(option)
        }
        return options
    }
}

class Filter{
    var name:String!
    var code:String!
    var options:[Option]!
    var type:FilterType!
    init(name:String, code:String? = nil, options:[Option], type:FilterType){
        self.name = name
        self.code = code
        self.options = options
        self.type = type
    }
}

class Option{
    var name:String!
    var code:String!
    var value:String!
    var selected:Bool!
    
    init(name:String?, code:String? = nil, value:String? = nil, selected:Bool? = nil){
        self.name = name
        self.code = code
        self.value = value
        self.selected = selected
    }
}
enum FilterType{
    case switchControl, menuContextControl
}
