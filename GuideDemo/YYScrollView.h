//
//  YYScrollView.h
//  GuideDemo
//
//  Created by Yong on 16/9/6.
//  Copyright © 2016年 Yong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYScrollViewDelegate <NSObject>

- (void)clickImageViewWithIndex:(NSInteger)index;

@end

@interface YYScrollView : UIView

@property (weak, nonatomic) id<YYScrollViewDelegate> delegate;

/** 数据源 */
@property (strong, nonatomic) NSMutableArray *imageList;

/** 站位图片 */
@property (copy, nonatomic) NSString *placeHolderImage;

/** 是否自动滚动，默认自动YES */
@property (assign, nonatomic) BOOL isAutoScrollPage;

/** pageControl中心点位置 */
@property (assign, nonatomic) CGPoint controlPoint;

@property (assign, nonatomic) BOOL pageControlHidden;

+ (instancetype)setUpScrollViewWithFrame:(CGRect)frame ImageList:(NSMutableArray *)imageList;

/** 开始自动滚动 */
- (void)startAutoScrollPage;

/** 停止自动滚动 */
- (void)stopAutoScrollPage;

@end
