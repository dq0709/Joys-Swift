//
//  DQChosenThemeTableViewController.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/25.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQChosenThemeTableViewController: UITableViewController {

    var theme:DQChosenLeftMenu?
    var dataArray:[DQChosen] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.theme?.name
        self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        self.tableView.backgroundColor = UIColor.clear
        let imageView = UIImageView.init(frame: SCREEN_BOUNDS)
        imageView.image = UIImage.init(named: "bgImage_640x1136_2")
        self.tableView.backgroundView = imageView
        self.setupHeaderView()
        self.sendRequest()
    }
    
    func setupHeaderView() -> Void {
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH*0.8))
        imageView.sd_setImage(with: URL.init(string: (self.theme?.imageURL!)!), placeholderImage: UIImage.init(named: "placeHolder"))
        self.tableView.tableHeaderView = imageView
    }
    
    func sendRequest() -> Void {
        unowned let uSelf = self
        DQNetWorkManager.requestData(type: .get, URLString: requestThemeData+String.init(describing: (self.theme?.ID)!), finishedCallback: { (response) in
            uSelf.dataArray = DQChosen.chosensData(json: response as! [String : Any])
            uSelf.tableView.reloadData()
        }) { (error) in
            uSelf.tableView.showWarning("您的网络不给力！")
        }
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
        return self.dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell") as? DQChosenTableViewCell
        if cell == nil {
            cell = DQChosenTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "ThemeCell")
        }
        let chosen = self.dataArray[indexPath.row]
        cell?.mainLabel.text = chosen.title
        cell?.mainImageView.sd_setImage(with: URL.init(string: chosen.imageURL!), placeholderImage: UIImage.init(named: "placeHolder"))
        return cell!
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CHOSEN_CELL_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chosen = self.dataArray[indexPath.row]
        let chosenDetailVC = DQChosenDetailViewController.init()
        chosenDetailVC.chosen = chosen
        chosenDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chosenDetailVC, animated: true)
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
