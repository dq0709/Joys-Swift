//
//  DQChosenTableViewCell.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQChosenTableViewCell: UITableViewCell {
    
    let mainLabel = UILabel.init()
    let mainImageView = UIImageView.init()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(mainLabel)
        self.contentView.addSubview(mainImageView)
        
       unowned let uSelf = self
        mainLabel.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(8)
            make?.left.mas_equalTo()(20)
            make?.bottom.mas_equalTo()(-30)
            make?.width.mas_equalTo()(SCREEN_WIDTH - CHOSEN_CELL_HEIGHT - 44.0)
            make?.right.mas_equalTo()(uSelf.mainImageView.mas_left)?.offset()(-16)
        }
        mainImageView.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(8)
            make?.height.mas_equalTo()(CHOSEN_CELL_HEIGHT - 16)
            make?.width.mas_equalTo()(CHOSEN_CELL_HEIGHT - 12)
        }
        mainLabel.textColor = UIColor.white
        mainLabel.numberOfLines = 0
        mainLabel.font = UIFont.systemFont(ofSize: 18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
