//
//  DQChosenHeader.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

let MAX_IMAGECOUNT = 5

class DQChosenHeader: NSObject {
    

    class func headerNews(json:[String:Any]) -> [DQChosen] {
        guard let array = json["recent"] as? [[String:Any]] else {
            return []
        }
        var headerNews:[DQChosen] = []
        let index = (array.count >= MAX_IMAGECOUNT) ? MAX_IMAGECOUNT : array.count
        for i in 0...index {
            var item:DQChosen? = DQChosen.chosenForHot(json: array[i])
            item = item ?? DQChosen.init()
            //guard let item = DQChosen.init(json: dic) else {
            //    return []
            //}
            headerNews.append(item!)
        }
        return headerNews
    }
    
    class func headerImages(json:[String:Any]) -> [NSString]{
        guard let array = json["recent"] as? [[String:Any]] else {
            return []
        }
        var headerImages:[String] = []
        let index = (array.count >= MAX_IMAGECOUNT) ? MAX_IMAGECOUNT : array.count
        for i in 0...index {
            let dic = array[i]
            var item:String? = dic["thumbnail"] as? String
            item = item ?? ""
            //guard let item = dic["thumbnail"] else {
           //     return []
           // }
            headerImages.append(item!)
        }
        return headerImages as [NSString]
    }
    
    class func headerTitles(json:[String:Any]) -> [NSString]{
        guard let array = json["recent"] as? [[String:Any]] else {
            return []
        }
        var headerTitles:[String] = []
        let index = (array.count >= MAX_IMAGECOUNT) ? MAX_IMAGECOUNT : array.count
        for i in 0...index {
            let dic = array[i]
            var item:String? = dic["title"] as? String
            item = item ?? ""
            headerTitles.append(item!)
        }
        return headerTitles as [NSString]
    }
    
}
