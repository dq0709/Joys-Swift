//
//  DQChosenDaily.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/26.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQChosenDaily: NSObject {
    
    var chosenItems:[DQChosen]?
    var date:String?
    
    init?(json:[String:Any]) {
        guard let date = json["date"] as? String,
            let items = json["stories"] as? [[String:Any]]
            else {
                return nil;
        }
        var chosenItems: Array<DQChosen> = []
        for dic in items {
            var item:DQChosen? = DQChosen.init(json: dic)
            item = item ?? DQChosen.init()
            //guard let item = DQChosen.init(json: dic) else {
            //    return nil
            //}
            chosenItems.append(item!)
        }
        self.date = date
        self.chosenItems = chosenItems
    }

    
}
