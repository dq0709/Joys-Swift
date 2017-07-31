//
//  DQJokeTableViewCell.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/27.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit

class DQJokeTableViewCell: UITableViewCell {
    
    let contentLabel = UILabel.init()
    let dateLabel = UILabel.init()
    let collectionBtn = UIButton.init()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(dateLabel)
        
        unowned let uSelf = self
        contentLabel.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(8)
            make?.left.mas_equalTo()(12)
            make?.bottom.mas_equalTo()(uSelf.dateLabel.mas_top)?.offset()(-8)
            make?.right.mas_equalTo()(-26)
        }
        dateLabel.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(12)
            make?.bottom.mas_equalTo()(-8)
            make?.size.mas_equalTo()(CGSize.init(width: 160, height: 20))
        }
        
        contentLabel.textColor = UIColor.white
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        
        dateLabel.textColor = UIColor.init(red: 5/255.0, green: 128/255.0, blue: 100/255.0, alpha: 1)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        
        self.contentView.addSubview(collectionBtn)
        collectionBtn.setImage(UIImage.init(named: "collection"), for: UIControlState.normal)
        collectionBtn.setImage(UIImage.init(named: "collection2"), for: UIControlState.selected)
        
        collectionBtn.mas_makeConstraints { (make) in
            make?.bottom.mas_equalTo()(-10)
            make?.right.mas_equalTo()(-10)
            make?.size.mas_equalTo()(CGSize.init(width: 20, height: 20))
        }
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
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
