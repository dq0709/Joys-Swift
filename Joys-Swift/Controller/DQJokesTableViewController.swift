//
//  DQJokesTableViewController.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/26.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQJokesTableViewController: UITableViewController {
    
    var page:NSInteger = 1
    var jokesArray:[DQJoke] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "段子"
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clear
        let imageV = UIImageView.init(frame: SCREEN_BOUNDS)
        imageV.image = UIImage.init(named: "bgImage_640x1136_2")
        self.tableView.backgroundView = imageV
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "collection2"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMyCollection))
        
        unowned let uSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            uSelf.page = 1
            uSelf.jokesArray.removeAll()
            uSelf.sendRequest()
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            uSelf.page += 1
            uSelf.sendRequest()
        })
        self.tableView.mj_header.beginRefreshing()
    }
    
    //MARK: - 网络请求
    func sendRequest() -> Void {
        let param = [
            "page":self.page,
            "pagesize":20,
            "key":"890608324a834555dac961cc5a95370b"
        ] as [String : Any]
        unowned let uSelf = self
        DQNetWorkManager.requestData(type: .get, URLString: "http://japi.juhe.cn/joke/content/text.from", parameters: param, finishedCallback: { (response) in
            uSelf.jokesArray += DQJoke.jokes(json: response as! [String : Any])
            uSelf.tableView.reloadData()
            uSelf.endRefresh()
        }) { (error) in
            uSelf.view.showWarning("网络问题，请稍后再试")
            uSelf.endRefresh()
        }
    }
    
    func endRefresh() -> Void {
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jokesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell") as? DQJokeTableViewCell
        if cell == nil {
            cell = DQJokeTableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "JokeCell")
        }
        let joke = self.jokesArray[indexPath.row]
        cell?.contentLabel.text = joke.content
        cell?.dateLabel.text = joke.updatetime
        cell?.collectionBtn.isSelected = joke.isCollectedInDB()
        cell?.collectionBtn.tag = indexPath.row
        cell?.collectionBtn.addTarget(self, action: #selector(collectionBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        return cell!
    }

    
    func collectionBtnClicked(sender:UIButton) -> Void {
        let joke = self.jokesArray[sender.tag]
        if !sender.isSelected {
            let success = DQJoke.insertJokeToDB(joke: joke)
            self.tableView.showWarning(success ? "收藏成功" : "收藏失败")
            sender.isSelected = success ? true : false
        }else {
            let success = DQJoke.removeJoke(ID: joke.hashId!)
            self.tableView.showWarning(success ? "取消收藏成功" : "取消收藏失败")
            sender.isSelected = success ? true : false
        }
        
    }
    

    
    func showMyCollection() -> Void {
        let jokeCollection = DQJokeColletionTableViewController.init()
        jokeCollection.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(jokeCollection, animated: true)
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
