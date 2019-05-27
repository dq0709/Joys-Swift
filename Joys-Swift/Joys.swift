//
//  Joys.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/24.
//  Copyright © 2017年 dq. All rights reserved.
//

import Foundation

let SCREEN_BOUNDS = UIScreen.main.bounds
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height


/** 最新数据 */
let requestLatestDataURL = "https://news-at.zhihu.com/api/4/news/latest"
/** 某天之前的数据  需要拼接date*/
let requestBeforeDataURL = "http://news.at.zhihu.com/api/4/news/before/"
/** 某条数据  需要拼接id*/
let requestNewsURL = "https://news-at.zhihu.com/api/4/news/"
/** 主题列表 */
let requestThemes = "https://news-at.zhihu.com/api/3/sections"
/** 获取某主题的数据 需要拼接主题id*/
let requestThemeData = "https://news-at.zhihu.com/api/3/section/"
/** 获取热门数据 */
let requestHotData = "https://news-at.zhihu.com/api/3/news/hot"
/** 获取评论总数和点赞总数 */
let requestExtraData = "https://news-at.zhihu.com/api/4/story-extra/"
/** 获取长评论  需要拼接id/long-comments */
let requestLongComments = "https://news-at.zhihu.com/api/4/story/"



let CHOSEN_CELL_HEIGHT:CGFloat = 120.0






