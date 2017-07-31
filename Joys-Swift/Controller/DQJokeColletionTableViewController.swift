//
//  DQJokeColletionTableViewController.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/26.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQJokeColletionTableViewController: UITableViewController {
    
    var jokesArr:[DQJoke] = [];
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的段子";
        
         self.jokesArr = DQJoke.getAllJokesFromDB()
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clear
        let imageV = UIImageView.init(frame: SCREEN_BOUNDS)
        imageV.image = UIImage.init(named: "bgImage_640x1136_2")
        self.tableView.backgroundView = imageV
        
        if self.jokesArr.count == 0 {
            self.tableView.showWarning("您还没有收藏哦~")
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
        return self.jokesArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "colletedJoke")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "colletedJoke")
            cell?.textLabel?.textColor = UIColor.white
            cell?.detailTextLabel?.textColor = UIColor.init(red: 5/255.0, green: 128/255.0, blue: 100/255.0, alpha: 1)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.textLabel?.numberOfLines = 0
            cell?.backgroundColor = UIColor.clear
        }
        let joke = self.jokesArr[indexPath.row]
        cell?.textLabel?.text = joke.content
        cell?.detailTextLabel?.text = joke.updatetime
        return cell!
    }

    
    //MARK: - 删除
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        unowned let uSelf = self
        let action = UITableViewRowAction.init(style: UITableViewRowActionStyle.destructive, title: "删除") { (action, indexPath) in
            uSelf.deletePoemAtIndexPath(indexPath: indexPath)
        }
        return [action]
    }
    
    func deletePoemAtIndexPath(indexPath:IndexPath) -> Void {
        let joke = self.jokesArr[indexPath.row]
        let alert = UIAlertController.init(title: "删除该收藏", message: "确定删除该条收藏吗？", preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        unowned let uSelf = self
        let done = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive) { (action) in
            if DQJoke.removeJoke(ID: joke.hashId!) {
                uSelf.jokesArr = DQJoke.getAllJokesFromDB()
                uSelf.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
            } else {
                uSelf.tableView.showWarning("删除失败")
            }
        }
        alert.addAction(cancel)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
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
