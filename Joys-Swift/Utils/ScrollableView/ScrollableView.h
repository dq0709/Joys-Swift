//
//  ScrollableView.h
//  ScrollView
//
//  Created by dq on 16/3/2.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollableView;

typedef void(^DIDTAP_BLOCK)(ScrollableView*, NSInteger);

@interface ScrollableView : UIView

@property (nonatomic,copy)DIDTAP_BLOCK didTap_block;

- (instancetype)initWithFrame:(CGRect)frame imageURLs:(NSArray*)imageURLs andTitles:(NSArray*)titles;

- (void)startAutoScroll;
- (void)stopScroll;
@end
