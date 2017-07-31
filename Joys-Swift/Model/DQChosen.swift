//
//  DQChosen.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/26.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQChosen: NSObject {
    var ID:NSNumber?
    var title:String?
    var imageURL:String?
    
    
    init?(json:[String:Any]) {
        guard let ID = json["id"] as? NSNumber,
            let images = json["images"] as? NSArray,
            let imageURL = images[0] as? String,
            let  title = json["title"] as? String
        else {
            return nil;
        }
        self.ID = ID
        self.imageURL = imageURL
        self.title = title
    }
    
    class func chosenForHot(json:[String:Any]) -> DQChosen? {
        let chosen = DQChosen()
        guard let ID = json["news_id"] as? NSNumber,
            let imageURL = json["thumbnail"] as? String,
            let  title = json["title"] as? String
            else {
                return nil;
        }
        chosen.ID = ID
        chosen.imageURL = imageURL
        chosen.title = title
        return chosen
    }
    
    override init() {
        super.init()
        self.ID = 0
        self.imageURL = ""
        self.title = ""
    }
    
    class func chosensData(json:[String:Any]) -> [DQChosen]{
        guard let items = json["stories"] as? [[String:Any]]
        else {
                return [];
        }
        var chosenItems: [DQChosen] = []
        for dic in items {
            let item:DQChosen? = DQChosen.init(json: dic)
            if item != nil {
                chosenItems.append(item!)
            }
        }
        return chosenItems
    }
    
    
}


/**
class BaseModel: NSObject {
    //setValuesForKeys是KVC方法
    //KVC的方法又是OC的方法，在运行时给对象发送消息，这点要求对象已经实例化完成。super.init()就是用来保证对象初始化完成。
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
    }
    
}
*/
