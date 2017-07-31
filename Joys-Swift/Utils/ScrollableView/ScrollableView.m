//
//  ScrollableView.m
//  ScrollView
//
//  Created by dq on 16/3/2.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "ScrollableView.h"
#import "TapableImageView.h"
#import "UIImageView+WebCache.h"

@interface ScrollableView()<UIScrollViewDelegate>
@property (nonatomic, strong)NSArray* imageURLs;
@property (nonatomic, strong)NSArray* titles;
@property (nonatomic, strong)UIImageView* leftImageView;
@property (nonatomic, strong)UIImageView* rightImageView;
@property (nonatomic, strong)TapableImageView* middleImageView;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, assign)NSInteger imageCount;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)UIPageControl* pageControl;
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)NSTimer *timer;
@end

@implementation ScrollableView

- (void)startAutoScroll {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}
- (void)autoScroll {
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width * 2, 0);
    [self scrollViewDidEndDecelerating:self.scrollView];
}

- (void)stopScroll {
    [self.timer invalidate];
}

- (instancetype)initWithFrame:(CGRect)frame imageURLs:(NSArray *)imageURLs andTitles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        self.imageURLs = imageURLs;
        self.titles = titles;
        self.imageCount = self.imageURLs.count;
        [self setScrollView];
        [self setupPageControl];
    }
    return self;
}

- (void)setScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    [self addSubview:self.scrollView];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[self.imageCount - 1]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    [self.scrollView addSubview:self.leftImageView];

    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width*2, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[1]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    [self.scrollView addSubview:self.rightImageView];

    self.middleImageView = [[TapableImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[0]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 3, self.bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"半透明图片"];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width + 8, self.bounds.size.height * 0.5, self.bounds.size.width - 16, self.bounds.size.height * 0.5)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.titles[0];
    
    __weak __typeof(self)weakSelf = self;
    [self.middleImageView addTapListenter:^(TapableImageView * sender) {
        weakSelf.didTap_block(weakSelf, weakSelf.currentIndex);
    }];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:imageView];
    [self.scrollView addSubview:self.titleLabel];
}

- (void)setupPageControl {
    self.pageControl = [[UIPageControl alloc]init];
    CGSize size = [self.pageControl sizeForNumberOfPages:self.imageCount];
    self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    self.pageControl.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.95);
    self.pageControl.currentPage = self.currentIndex;
    self.pageControl.numberOfPages = self.imageCount;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:self.pageControl];
}

//滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //更换图片
    int i =(self.scrollView.contentOffset.x / self.bounds.size.width)-1;
    self.currentIndex = (self.currentIndex + self.imageCount +i)%self.imageCount;
    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[self.currentIndex]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[(self.currentIndex + self.imageCount-1)%self.imageCount]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[(self.currentIndex + self.imageCount+1)%self.imageCount]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.pageControl.currentPage = self.currentIndex;
    self.titleLabel.text = self.titles[self.currentIndex];
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
}

@end
