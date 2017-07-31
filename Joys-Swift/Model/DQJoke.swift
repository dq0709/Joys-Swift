//
//  DQJoke.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQJoke: NSObject {
    
    var hashId : String?
    var content : String?
    var updatetime : String?
    
    init?(json:[String:Any]){
        guard let hashId = json["hashId"] as? String,
            let content = json["content"] as? String,
            let updatetime = json["updatetime"] as? String
        else {
                return nil
        }
        self.hashId = hashId
        self.content = content
        self.updatetime = updatetime
    }
    
    override init() {
        super.init()
        self.hashId = ""
        self.content = ""
        self.updatetime = ""
    }

    class func jokes(json:[String:Any]) -> [DQJoke] {
        guard let data = json["result"] as? [String:Any] else {
            return []
        }
        guard let dataArr = data["data"] as? [[String:Any]] else {
            return []
        }
        var jokes:[DQJoke] = []
        for dic in dataArr {
            var item:DQJoke? = DQJoke.init(json:dic)
            item = item ?? DQJoke.init()
            jokes.append(item!)
        }
        return jokes
    }
    
    class func getAllJokesFromDB() -> [DQJoke] {
        let database = DQDBManager.sharedDatabase
        database.open()
        let resultSet = database.executeQuery("select * from joke", withParameterDictionary: nil)
        var jokes:[DQJoke]? = []
        while (resultSet?.next())! {
            let item:DQJoke? = DQJoke.init()
            item?.hashId = resultSet?.object(forColumn: "hashId") as? String
            item?.content = resultSet?.string(forColumn: "content")
            item?.updatetime = resultSet?.string(forColumn: "updatetime")
            jokes?.append(item!)
        }
        database.close()
        return jokes!
    }
    
    func isCollectedInDB() -> Bool {
        let database = DQDBManager.sharedDatabase
        database.open()
        let resultSet = database.executeQuery("select * from joke where hashId = ?", withArgumentsIn: [self.hashId!])
        if (resultSet?.next())! {
            return true
        } else {
            return false
        }
    }
    
    class func insertJokeToDB(joke:DQJoke) -> Bool {
        let database = DQDBManager.sharedDatabase
        database.open()
        let isSuccess = database.executeUpdate("insert into joke (hashId, content, updatetime) values (?, ?, ?)", withArgumentsIn: [joke.hashId!, joke.content!, joke.updatetime!])
        database.close()
        return isSuccess
    }
    
    class func removeJoke(ID:String) -> Bool {
        let database = DQDBManager.sharedDatabase
        database.open()
        let isSuccess = database.executeUpdate("delete from joke where hashId = ?", withArgumentsIn: [ID])
        database.close()
        return isSuccess
    }

    
}
