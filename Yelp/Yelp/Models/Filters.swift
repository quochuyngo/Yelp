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
        
        Filter(name: "Popular", code: "deals_filter",
               options: [
                Option(name: "Offering a deal", selected: false)],
               type: FilterType.switchControl),
        
        Filter(name: "Sort by", code: "sort",
               options: [Option(name: "Best Matched", value: "0", selected: true),
                         Option(name: "Distance", value: "1", selected: false),
                         Option(name: "Rating", value: "2", selected: false)],
               type: FilterType.menuContextControl),
        Filter(name: "Distance", code: "radius_filter",
               options: [Option(name: "Auto", value: "", selected: true),
                         Option(name: "1 mil", value: "1609", selected: false),
                         Option(name:"5 mil", value: "8045", selected: false),
                         Option(name:"10 mil", value: "16090", selected: false)],
               type: FilterType.menuContextControl),
        Filter(name: "Category", code: "category_filter",
               options: Filters.getCategories(),
            type: FilterType.switchControl)
    ]
    static func getCategories()->[Option]{
        var options = [Option]()
        for category in Category.getCategories(){
            let option = Option(name: category["name"], value: category["code"], selected: false)
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
    var isCollapse:Bool!
    
    init(name:String?, code:String? = nil, value:String? = nil, selected:Bool? = nil, isCollapse:Bool? = nil){
        self.name = name
        self.code = code
        self.value = value
        self.selected = selected
        self.isCollapse = isCollapse
    }
}

class Singleton{
    static let sharedInstance = Singleton()
    var filters:Filters!
    private init(){
        filters = Filters()
    }
    func getFilters()->[Filter]{
        return filters.filters
    }
}

enum FilterType{
    case switchControl, menuContextControl
}
