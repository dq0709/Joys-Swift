//
//  DQNavi.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/25.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQNavi: WMPageController {
    
    static let standardNavi: UINavigationController = {
        let vc = DQNavi.init(viewControllerClasses: DQNavi.vcClasses(), andTheirTitles: DQNavi.itemNames())
        vc.keys = DQNavi.vcKeys()
        vc.values = DQNavi.vcValues()
        var standardNavi = UINavigationController.init(rootViewController: vc)
        return standardNavi
    }()
    
    func showMyCollection() -> Void{
        let picCollection = DQPicCollectionViewController.init()
        picCollection.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(picCollection, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "美图";
        self.view.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "collection2"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(DQNavi.showMyCollection))
    }
    
    
    class func itemNames() -> [String] {
        return ["猫咪","搞笑","壁纸","美女","动漫","宠物", "风景"]
    }
    
    class func vcClasses() -> [AnyClass] {
        var arr:[AnyClass] = []
        for _ in DQNavi.itemNames() {
            arr.append(DQPicturesViewController.classForCoder())
        }
        return arr
    }
    
    class func vcValues() -> NSMutableArray {
        let arr:NSMutableArray = []
        for index in 0 ... DQNavi.itemNames().count-1 {
            arr.add(index)
        }
        return arr
    }
    
    class func vcKeys() -> NSMutableArray {
        let keys:NSMutableArray = []
        for _ in DQNavi.itemNames() {
            keys.add("infoType")
        }
        return keys
    }
    
}
