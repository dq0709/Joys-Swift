//
//  DQChosenTableViewController.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/25.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQChosenTableViewController: UITableViewController {
    
    var dataArray:[DQChosenDaily] = []
    var date:String?
    let NAVBAR_CHANGE_POINT:CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clear)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
        self.sideMenuViewController.navigationItem.title = "精选"
        self.sideMenuViewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showLeftMenu))
        self.sendRequestAndSetupHeader()
        
        unowned let uSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            uSelf.dataArray.removeAll()
            uSelf.sendRequest()
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            uSelf.sendRequest()
        })
        self.tableView.mj_header.beginRefreshing()
        
    }
    
    
    //MARK: - 推出左菜单
    func showLeftMenu() -> Void {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    //MARK: - 网络请求
    func sendRequest() -> Void {
        let daily = self.dataArray.last
        self.date = daily?.date
        let url = ((self.date) != nil) ? requestBeforeDataURL+self.date! : requestLatestDataURL
        unowned let uSelf = self
        DQNetWorkManager.requestData(type: .get, URLString: url, finishedCallback: { (response) in
            let dailyNew = DQChosenDaily.init(json: response as! [String : Any])
            uSelf.dataArray.append(dailyNew!)
            uSelf.tableView.reloadData()
            uSelf.tableView.mj_header.endRefreshing()
            uSelf.tableView.mj_footer.endRefreshing()
        }) { (error) in
            uSelf.tableView.showWarning("您的网络不给力！")
            uSelf.tableView.mj_header.endRefreshing()
            uSelf.tableView.mj_footer.endRefreshing()
        }
    }
    
    //头视图
    func sendRequestAndSetupHeader() -> Void {
        unowned let uSelf = self
        DQNetWorkManager.requestData(type: .get, URLString: requestHotData, finishedCallback: { (response) in
            let headerView = ScrollableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*0.7), imageURLs: DQChosenHeader.headerImages(json: response as! [String : Any]), andTitles: DQChosenHeader.headerTitles(json: response as! [String : Any]))
            let news = DQChosenHeader.headerNews(json: response as! [String : Any])
            headerView?.didTap_block = { (sv:ScrollableView?, currentIndex:Int) in
                let detailVC = DQChosenDetailViewController.init()
                detailVC.chosen = news[currentIndex]
                detailVC.hidesBottomBarWhenPushed = true
                uSelf.navigationController?.pushViewController(detailVC, animated: true)
            }
            uSelf.tableView.tableHeaderView = headerView
        }) { (error) in
            uSelf.view.showWarning("您的网络不给力！")
        }
    }
    
    //MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let color = UIColor.init(red: 132/255.0, green: 175/255.0, blue: 109/255.0, alpha: 1)
        let height = self.tableView.tableHeaderView?.bounds.size.height
        let offsetY = scrollView.contentOffset.y
        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha = 1 - ((NAVBAR_CHANGE_POINT + height! - offsetY - 64) / height!)
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.withAlphaComponent(alpha))
        } else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.withAlphaComponent(0))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollViewDidScroll(self.tableView)
        let header =  self.tableView.tableHeaderView as? ScrollableView
        header?.stopScroll()
        header?.startAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let header =  self.tableView.tableHeaderView as? ScrollableView
        header?.stopScroll()
        self.navigationController?.navigationBar.lt_reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let daily = self.dataArray[section]
        return daily.chosenItems!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ChosenCell") as? DQChosenTableViewCell
        if cell==nil {
            cell = DQChosenTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "ChosenCell")
        }
        let daily = self.dataArray[indexPath.section]
        let chosen = daily.chosenItems?[indexPath.row]
        cell?.mainLabel.text = chosen?.title
        cell?.mainImageView.sd_setImage(with: URL.init(string: (chosen?.imageURL)!), placeholderImage: UIImage.init(named: "placeHolder"))
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(CHOSEN_CELL_HEIGHT)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let daily = self.dataArray[indexPath.section]
        let chosen = daily.chosenItems?[indexPath.row]
        let chosenDetailVC = DQChosenDetailViewController.init()
        chosenDetailVC.chosen = chosen
        chosenDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chosenDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = (self.dataArray[section]).date
        let index = date?.index((date?.startIndex)!, offsetBy: 4)
        let indexEnd = date?.index((date?.endIndex)!, offsetBy: -2)
        let title = (date?.substring(to: index!))! + "-" + (date?.substring(with: index!..<indexEnd!))! + "-" + (date?.substring(from: indexEnd!))!
        return title
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
        view.backgroundColor = UIColor.init(red: 132/255.0, green: 154/255.0, blue: 109/255.0, alpha: 0.8)
        let label = UILabel.init()
        view.addSubview(label)
        label.mas_makeConstraints { (make) in
            make?.edges.mas_equalTo()(0)
        }
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        return view
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
