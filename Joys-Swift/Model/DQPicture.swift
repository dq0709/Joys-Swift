//
//  DQPicture.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQPicture: NSObject {
    var ID : NSNumber?
    var url : String?
    var height : Double?
    var width : Double?
    
    init?(json:[String:Any]){
        guard let ID = json["id"] as? NSNumber,
            let url = json["url"] as? String,
            let height = json["height"] as? Double,
            let width = json["width"] as? Double
        else {
            return nil
        }
        self.ID = ID
        self.url = url
        self.height = height
        self.width = width
    }
    
    override init() {
        super.init()
        self.ID = 0
        self.url = ""
        self.height = 0
        self.width = 0
    }
    
    class func pictures(json:[String:Any]) -> [DQPicture] {
        guard let dataArr = json["data"] as? [[String:Any]] else {
            return []
        }
        var pictures:[DQPicture] = []
        for dic in dataArr {
            var item:DQPicture? = DQPicture.init(json:dic)
            item = item ?? DQPicture.init()
            pictures.append(item!)
        }
        return pictures
    }
    
    class func getAllPicturesFromDB() -> [DQPicture] {
        let database = DQDBManager.sharedDatabase
        database.open()
        let resultSet = database.executeQuery("select * from picture", withParameterDictionary: nil)
        var pics:[DQPicture]? = []
        while (resultSet?.next())! {
            let item:DQPicture? = DQPicture.init()
            item?.ID = resultSet?.object(forColumn: "C_ID") as? NSNumber
            item?.url = resultSet?.string(forColumn: "url")
            item?.width = resultSet?.double(forColumn: "width")
            item?.height = resultSet?.double(forColumn: "height")
            pics?.append(item!)
        }
        database.close()
        return pics!
    }
    
    func isCollectedInDB() -> Bool {
        let database = DQDBManager.sharedDatabase
        database.open()
        let resultSet = database.executeQuery("select * from picture where C_ID = ?", withArgumentsIn: [self.ID!])
        if (resultSet?.next())! {
            return true
        } else {
            return false
        }
    }
    
    class func insertPictureToDB(picture:DQPicture) -> Bool {
        let database = DQDBManager.sharedDatabase
        database.open()
        let isSuccess = database.executeUpdate("insert into picture (C_ID, url, height, width) values (?, ?, ?, ?)", withArgumentsIn: [picture.ID!, picture.url!, picture.height!, picture.width!])
        database.close()
        return isSuccess
    }
    
    class func removePicure(ID:NSNumber) -> Bool {
        let database = DQDBManager.sharedDatabase
        database.open()
        let isSuccess = database.executeUpdate("delete from picture where C_ID = ?", withArgumentsIn: [ID])
        database.close()
        return isSuccess
    }
    
    class func getURLByType(type:NSInteger, page:NSInteger) -> String {
        let titles = DQNavi.itemNames()
        return String.init("http://mapp.tiankong.com/search?key=\(titles[type])&pageNum=\(page)&pageSize=20").addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    
}
