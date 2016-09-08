//
//  YYScrollView.m
//  GuideDemo
//
//  Created by Yong on 16/9/6.
//  Copyright © 2016年 Yong. All rights reserved.
//

#import "YYScrollView.h"
#import "UIImageView+WebCache.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define YYSCROLLVIEW_HEIGHT self.bounds.size.height

@interface YYScrollView()<UIScrollViewDelegate>
{
    UIScrollView *mainScrollview;
    UIPageControl *pageControl;
    NSInteger pageIndex;
    UIImageView *currentImageView;
    NSTimer *_timer;
}

@end

@implementation YYScrollView

+ (instancetype)setUpScrollViewWithFrame:(CGRect)frame ImageList:(NSMutableArray *)imageList{

    YYScrollView *scrollview = [[YYScrollView alloc]initWithFrame:frame];
    scrollview.imageList = [NSMutableArray arrayWithArray:imageList];
    return scrollview;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpScrollView];
        [self setUpProperty];
    }
    return self;
}

#pragma mark 初始化视图
- (void)setUpScrollView{

    mainScrollview = [[UIScrollView alloc]initWithFrame:self.bounds];
    mainScrollview.contentSize = CGSizeMake(WIDTH * 3, YYSCROLLVIEW_HEIGHT);
    mainScrollview.showsHorizontalScrollIndicator = NO;
    mainScrollview.showsVerticalScrollIndicator = NO;
    mainScrollview.userInteractionEnabled = YES;
    mainScrollview.pagingEnabled = YES;
    mainScrollview.bounces = NO;
    mainScrollview.delegate = self;
    mainScrollview.contentOffset = CGPointMake(WIDTH, 0);
    [self addSubview:mainScrollview];

    pageControl = [[UIPageControl alloc]init];
    pageControl.currentPage = 0;
    pageControl.center = CGPointMake(WIDTH/2, YYSCROLLVIEW_HEIGHT-20);
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    [self addSubview:pageControl];
    pageIndex = 0;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
    [mainScrollview addGestureRecognizer:tap];

}
- (void)clickAction{
    if ([self.delegate respondsToSelector:@selector(clickImageViewWithIndex:)]) {
        [self.delegate clickImageViewWithIndex:pageIndex];
    }
}
- (void)setUpProperty{

    self.isAutoScrollPage = YES;

}
#pragma mark 自动滚动
- (void)AutoScrollAction{

    pageIndex ++;

    if (pageIndex>_imageList.count-1) {
        pageIndex = 0;
    }
    [UIView animateWithDuration:1 animations:^{

        mainScrollview.contentOffset = CGPointMake(WIDTH*2, 0);
    } completion:^(BOOL finished) {
        mainScrollview.contentOffset = CGPointMake(WIDTH, 0);
        [self scrollviewImage:_imageList];
    }];
    pageControl.currentPage = pageIndex;

}
- (void)setImageList:(NSMutableArray *)imageList{
    _imageList = imageList;

    pageControl.numberOfPages = imageList.count;
    [self scrollviewImage:imageList];
}

#pragma mark   创建复用的三个imageview显示图片
-(void)scrollviewImage:(NSArray *)imageList
{

    for (UIView *view in mainScrollview.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    //  上一个图片
    UIImageView *lastImageView = [[UIImageView alloc]init];
    NSString *lastName = pageIndex-1>=0 ? imageList[pageIndex -1]:[imageList lastObject];
    [lastImageView sd_setImageWithURL:[NSURL URLWithString:lastName] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
    lastImageView.userInteractionEnabled = YES;
    lastImageView.frame = CGRectMake(0, 0, WIDTH, YYSCROLLVIEW_HEIGHT);
    [mainScrollview addSubview:lastImageView];

    //  当前图片
    currentImageView = [[UIImageView alloc]init];
    [currentImageView sd_setImageWithURL:[NSURL URLWithString:imageList[pageIndex]] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
    currentImageView.userInteractionEnabled = YES;
    currentImageView.frame = CGRectMake(WIDTH, 0, WIDTH, YYSCROLLVIEW_HEIGHT);
    [mainScrollview addSubview:currentImageView];

    //  下一个图片
    UIImageView *nextImageView = [[UIImageView alloc]init];
    NSString *nextName = pageIndex + 1<imageList.count ? imageList[pageIndex+1] : [imageList firstObject];
    nextImageView.userInteractionEnabled = YES;
    [nextImageView sd_setImageWithURL:[NSURL URLWithString:nextName] placeholderImage:[UIImage imageNamed:self.placeHolderImage]];
    nextImageView.frame = CGRectMake(WIDTH*2, 0, WIDTH, YYSCROLLVIEW_HEIGHT);
    [mainScrollview addSubview:nextImageView];

}
#pragma mark   滚动结束代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == mainScrollview) {
        CGFloat sWidth = self.frame.size.width;

        int index = scrollView.contentOffset.x/self.frame.size.width;
        if (index>1) {
            pageIndex = pageIndex+1<_imageList.count ? pageIndex+1 : 0;

            [UIView animateWithDuration:1 animations:^{
                mainScrollview.contentOffset = CGPointMake(sWidth*2, 0);
            } completion:^(BOOL finished) {
                mainScrollview.contentOffset = CGPointMake(sWidth, 0);
                [self scrollviewImage:_imageList];

            }];

        }else if (index < 1){

            pageIndex = pageIndex-1>=0 ? pageIndex-1 : _imageList.count-1;
            [UIView animateWithDuration:1 animations:^{
                mainScrollview.contentOffset = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
                mainScrollview.contentOffset = CGPointMake(sWidth, 0);
                [self scrollviewImage:_imageList];

            }];
        }else{
            NSLog(@"————没有滚动");
        }
        pageControl.currentPage = pageIndex;
    }
}
#pragma mark   Auto Scroll
- (void)setIsAutoScrollPage:(BOOL)isAutoScrollPage{
    _isAutoScrollPage = isAutoScrollPage;
    [self resetTimer];

    if (isAutoScrollPage) {
        [self startAutoScrollPage];
    }
}

- (void)startAutoScrollPage{
    if (!_timer) {
        [self setUpTimer];
    }

}
- (void)stopAutoScrollPage{
    if (_timer) {
        [self resetTimer];
    }

}
- (void)setUpTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(AutoScrollAction) userInfo:nil repeats:YES];
    _timer = timer;
}
- (void)resetTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)setControlPoint:(CGPoint)controlPoint{
    _controlPoint = controlPoint;
    pageControl.center = controlPoint;
}
- (void)setPageControlHidden:(BOOL)pageControlHidden{
    _pageControlHidden = pageControlHidden;
    pageControl.hidden = pageControlHidden;


}
- (void)dealloc{

     [self resetTimer];

}
@end
