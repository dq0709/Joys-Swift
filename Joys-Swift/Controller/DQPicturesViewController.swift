//
//  DQPicturesViewController.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQPicturesViewController: UIViewController, UIScrollViewDelegate, PSCollectionViewDelegate, PSCollectionViewDataSource, MWPhotoBrowserDelegate {
    
    var infoType:NSInteger?
    let collecView = PSCollectionView.init()
    var picturesArray:[DQPicture] = []
    var sumNumber = 1
    let browser = MWPhotoBrowser.init()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key=="infoType" {
            self.infoType = value as? NSInteger
        } else {
            super.setValue(value, forKey: key)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red:132/255.0, green:175/255.0, blue:109/255.0, alpha:0.3)
        self.collecView.delegate = self
        self.collecView.collectionViewDelegate = self
        self.collecView.collectionViewDataSource = self
        self.view.addSubview(collecView)
        self.collecView.numColsPortrait = 2
        self.collecView.numColsLandscape = 3
        self.collecView.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(-8)
            make?.left.mas_equalTo()(-8)
            make?.right.mas_equalTo()(-8)
            make?.bottom.mas_equalTo()(-8)
        }
        
        self.browser.delegate = self
        self.browser.zoomPhotosToFill = true
        self.browser.enableSwipeToDismiss = true
        
        unowned let uSelf = self
        self.collecView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { 
            uSelf.sumNumber = 1
            uSelf.picturesArray.removeAll()
            uSelf.sendRequest()
        })
        self.collecView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { 
            uSelf.sumNumber += 1
            uSelf.sendRequest()
        })
        self.collecView.mj_header.beginRefreshing()
    }
    
    
    //MARK: - 网络请求
    func sendRequest() -> Void {
        unowned let uSelf = self
        DQNetWorkManager.requestData(type: .get, URLString: DQPicture.getURLByType(type:uSelf.infoType ?? 0,page:uSelf.sumNumber), finishedCallback: { (response) in
            uSelf.picturesArray += DQPicture.pictures(json: response as! [String : Any])
            uSelf.collecView.reloadData()
            uSelf.endRefresh()
        }) { (error) in
            uSelf.view.showWarning("网络问题，请稍后再试")
            uSelf.endRefresh()
        }
    }
    
    func endRefresh() -> Void {
        self.collecView.mj_header.endRefreshing()
        self.collecView.mj_footer.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - collectionView
    func numberOfRows(in collectionView: PSCollectionView!) -> Int {
        return  self.picturesArray.count;
    }
    
    func collectionView(_ collectionView: PSCollectionView!, heightForRowAt index: Int) -> CGFloat {
        let pic = self.picturesArray[index]
        let width = pic.width
        let height = pic.height
        return (SCREEN_HEIGHT / 2 - 16) * CGFloat(height! / width!)
    }
    
    func collectionView(_ collectionView: PSCollectionView!, cellForRowAt index: Int) -> PSCollectionViewCell! {
        var cell = collectionView.dequeueReusableView(for: PSCollectionViewCell.classForCoder())
        if cell == nil {
            cell = PSCollectionViewCell.init(frame: CGRect.zero)
            let imageV = UIImageView.init()
            imageV.backgroundColor = UIColor.lightGray
            imageV.contentMode = UIViewContentMode.scaleAspectFill
            imageV.layer.masksToBounds = true
            cell?.addSubview(imageV)
            imageV.tag = 100
        }
        let iv = cell?.viewWithTag(100) as! UIImageView
        iv .mas_makeConstraints { (make) in
            make?.edges.mas_equalTo()(10)
        }
        let pic = self.picturesArray[index]
        iv.sd_setImage(with: URL.init(string: pic.url!))
        return cell
    }
    
    func collectionView(_ collectionView: PSCollectionView!, didSelect cell: PSCollectionViewCell!, at index: Int) {
        self.browser.setCurrentPhotoIndex(UInt(index))
        let nc = UINavigationController.init(rootViewController: self.browser)
        self.present(nc, animated: true, completion: nil)
    }
    
    
    //MARK: - MWPhotoBrowserDelegate
    func didClickExtroButton() -> Void{
        let index = Int(self.browser.currentIndex)
        let picture = self.picturesArray[index]
        unowned let uSelf = self
        if picture.isCollectedInDB() {
            uSelf.browser.view.showWarning("您已经收藏过此图片")
            return
        }
        let success = DQPicture.insertPictureToDB(picture: picture)
        self.browser.view.showWarning(success ? "收藏成功" : "收藏失败")
    }
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.picturesArray.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if Int(index)<self.picturesArray.count {
            let pic = self.picturesArray[Int(index)]
            return MWPhoto.init(url: URL.init(string: pic.url!))
        }
        return nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
