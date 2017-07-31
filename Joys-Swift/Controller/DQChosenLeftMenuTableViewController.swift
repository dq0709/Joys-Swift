//
//  DQChosenLeftMenuTableViewController.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/25.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQChosenLeftMenuTableViewController: UITableViewController {
    
    var menuArray:[DQChosenLeftMenu] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        unowned let uSelf = self
        DQNetWorkManager.requestData(type: .get, URLString: requestThemes, finishedCallback: { (response) in
            uSelf.menuArray = DQChosenLeftMenu.themes(json: response as! [String : Any] )
            uSelf.tableView.reloadData()
        }) { (error) in
            uSelf.view.showWarning("您的网络不给力！")
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
        return self.menuArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MENU")
        if cell==nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "MENU")
            cell?.textLabel?.textColor = UIColor.white
            cell?.backgroundColor = UIColor.clear
        }
        cell?.imageView?.image = UIImage.init(named: "t\(indexPath.row%8).png")
        let item = self.menuArray[indexPath.row]
        cell?.textLabel?.text = item.name
        return cell!
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let themeVC = DQChosenThemeTableViewController()
        themeVC.theme = self.menuArray[indexPath.row]
        self.sideMenuViewController.contentViewController.navigationController?.pushViewController(themeVC, animated: true)
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
