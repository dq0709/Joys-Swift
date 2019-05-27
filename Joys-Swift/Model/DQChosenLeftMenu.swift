//
//  DQChosenLeftMenu.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQChosenLeftMenu: NSObject {
    
    var ID:NSNumber?
    var name:String?
    var imageURL:String?
    var cDescription:String?
    
    init?(json:[String:Any]) {
        guard let ID = json["id"] as? NSNumber,
            let imageURL = json["thumbnail"] as? String,
            let  cDescription = json["description"] as? String,
            let  name = json["name"] as? String
            else {
                return nil;
        }
        self.ID = ID
        self.imageURL = imageURL
        self.cDescription = cDescription
        self.name = name
    }
    
    override init() {
        super.init()
        self.ID = 0
        self.imageURL = ""
        self.name = ""
        self.cDescription = ""
    }
    
    class func themes(json:[String:Any]) -> [DQChosenLeftMenu] {
        guard let array = json["data"] as? [[String:Any]] else {
            return []
        }
        var themes:[DQChosenLeftMenu] = []
        for dic in array {
            var item:DQChosenLeftMenu? = DQChosenLeftMenu.init(json: dic)
            item = item ?? DQChosenLeftMenu.init()
            themes.append(item!)
        }
        return themes
    }
    
}
