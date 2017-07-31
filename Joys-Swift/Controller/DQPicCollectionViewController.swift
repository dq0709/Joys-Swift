//
//  DQPicCollectionViewController.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQPicCollectionViewController: UIViewController, UIScrollViewDelegate, PSCollectionViewDelegate, PSCollectionViewDataSource, MWPhotoBrowserDelegate {

    var picturesArray:[DQPicture] = []
    let collecView = PSCollectionView.init()
    let browser = MWPhotoBrowser.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的美图";
        self.picturesArray = DQPicture.getAllPicturesFromDB()
        
        self.view.backgroundColor = UIColor.init(red:209/255.0, green:227/255.0, blue:210/255.0, alpha:1)
        self.collecView.delegate = self
        self.collecView.collectionViewDelegate = self
        self.collecView.collectionViewDataSource = self
        self.view.addSubview(collecView)
        self.collecView.numColsPortrait = 2
        self.collecView.numColsLandscape = 3
        self.collecView.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(-8)
            make?.left.mas_equalTo()(-12)
            make?.right.mas_equalTo()(-8)
            make?.bottom.mas_equalTo()(-8)
        }
        
        self.browser.delegate = self
        self.browser.zoomPhotosToFill = true
        self.browser.enableSwipeToDismiss = true

        if self.picturesArray.count == 0 {
            self.collecView.showWarning("您还没有收藏哦~")
        }
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
        let alert = UIAlertController.init(title: "删除该收藏", message: "确定删除该条收藏吗？", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        unowned let uSelf = self
        let done = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (action) in
            if DQPicture.removePicure(ID: picture.ID!) {
                uSelf.picturesArray = DQPicture.getAllPicturesFromDB()
                uSelf.collecView.reloadData()
                uSelf.browser.reloadData()
            } else {
                uSelf.browser.view.showWarning("删除失败")
            }
        }
        alert.addAction(cancel)
        alert.addAction(done)
        self.browser.present(alert, animated: true, completion: nil)
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
