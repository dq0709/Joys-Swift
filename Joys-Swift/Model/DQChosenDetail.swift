//
//  DQChosenDetail.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQChosenDetail: NSObject {

    var body:String?
    var css:String?
    
    init?(json:[String:Any]) {
        guard let body = json["body"] as? String,
            let images = json["css"] as? NSArray,
            let css = images[0] as? String
            else {
                return nil;
        }
        self.body = body
        self.css = css
    }
    
}
