//
//  DQChosenDetailViewController.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/31.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit
import WebKit

class DQChosenDetailViewController: UIViewController {
    
    var chosen:DQChosen?
    var webView : WKWebView?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView = WKWebView.init(frame: SCREEN_BOUNDS)
        self.view.addSubview(self.webView!)
        self.sendRequest()
    }
    
    func sendRequest() -> Void {
        let request = requestNewsURL+String.init(describing: (self.chosen?.ID)!)
        DQNetWorkManager.requestData(type: .get, URLString:request , finishedCallback: { (response) in
            let chosenDetail = DQChosenDetail.init(json: response as! [String : Any])
            if chosenDetail?.body != "" && chosenDetail?.body != nil {
                let strHead = "<html> <head><style type=\"text/css\">div{font-size: 48px}h2 {font-size: 68px; color: #006000}div.question {background:#859B6E}body {color:white; background:#859B6E}img{width:100%; height:auto}span{font-size: 38px}img.avatar{width: 100px; height:100px;border-radius:50%; overflow:hidden}</style></head><body><br>"
                let strFoot = "</body></html>"
                self.webView?.loadHTMLString(strHead + (chosenDetail?.body)! + strFoot, baseURL: nil)
            } else {
                self.view.showWarning("您查看的内容不存在")
            }
        }) { (error) in
            self.view.showWarning("您的网络不给力！")
        }
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
