//
//  DQNetWorkManager.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/25.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class DQNetWorkManager: NSObject {
    
    class func requestData(type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> (), failedCallback :  @escaping (_ result : Error) -> ()) {
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            // 3.获取结果
            guard let result = response.result.value else {
                //print(response.result.error!)
                failedCallback(response.result.error!)
                return
            }
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }
    

    
   
//    +(void)sendRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    successBlock(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    failureBlock(error);
//    }];
//    }
    
}
