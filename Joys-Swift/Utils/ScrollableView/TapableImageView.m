//
//  TapableImageView.m
//  ScrollView
//
//  Created by dq on 16/3/2.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "TapableImageView.h"

@implementation TapableImageView

-(void)addTapListenter:(TAP_BLOCK)tap_block {
    self.tap_block = tap_block;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}
-(void)tap:(UITapGestureRecognizer*)sender {
    self.tap_block(self);
}

@end
