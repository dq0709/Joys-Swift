//
//  TapableImageView.h
//  ScrollView
//
//  Created by dq on 16/3/2.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TapableImageView;
typedef void(^TAP_BLOCK)(TapableImageView*);

@interface TapableImageView : UIImageView
@property (nonatomic, copy)TAP_BLOCK tap_block;
-(void)addTapListenter:(TAP_BLOCK)tap_block;
@end
