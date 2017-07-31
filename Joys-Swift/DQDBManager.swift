//
//  DQDBManager.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/24.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQDBManager {
    
    //static let sharedDatabase = DQDBManager()
    
    
    static let sharedDatabase: FMDatabase = {
        
        var database = FMDatabase()
        // 初始化处理
        //1.移动数据库文件到/Documents/sqlite.db
        let atPath = Bundle.main.path(forResource: "Joys", ofType: "db")
        let toPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String).appending("/sqlite.db")
        if(!FileManager.default.fileExists(atPath: toPath)){
            do{
                try FileManager.default.copyItem(atPath: atPath!, toPath: toPath)
                print("数据库操作==== 复制数据库成功！")
            }catch let nserror as NSError{
                fatalError("Error: \(nserror.localizedDescription)")
                //print("Error: \(nserror.localizedDescription)")
            }
        }
        database = FMDatabase.init(path: toPath)
        return database
    }()
 
    
}
