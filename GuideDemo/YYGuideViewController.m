//
//  YYGuideViewController.m
//  GuideDemo
//
//  Created by Yong on 16/9/1.
//  Copyright © 2016年 Yong. All rights reserved.
//

#import "YYGuideViewController.h"

@interface YYGuideViewController ()<UIScrollViewDelegate>
{

    UIPageControl *pageControl;
}
@end

@implementation YYGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self loadScrollview];

}

- (void)loadScrollview{

    CGFloat WIDTH = self.view.bounds.size.width;
    CGFloat HEIGHT = self.view.bounds.size.height;

    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollview.bounces = NO;
    scrollview.pagingEnabled = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.contentSize = CGSizeMake(WIDTH * 3, HEIGHT);
    scrollview.delegate = self;
    [self.view addSubview:scrollview];



    for (int i = 0; i < 3; i ++) {

        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Welcome_Page_%d",i+1]];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        imageview.image = image;

        if (i == 2) {

            imageview.userInteractionEnabled = YES;
            UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
            nextButton.frame = CGRectMake((WIDTH - 120)/2, HEIGHT-HEIGHT*0.19, 120, 44);
            [nextButton setTitle:@"点击进入" forState:UIControlStateNormal];
            [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            nextButton.layer.borderWidth = 1;
            nextButton.layer.borderColor = [UIColor blackColor].CGColor;
            nextButton.layer.masksToBounds = YES;
            nextButton.layer.cornerRadius = 5;
            [nextButton addTarget:self action:@selector(toNext) forControlEvents:UIControlEventTouchUpInside];
            [imageview addSubview:nextButton];

        }
        [scrollview addSubview:imageview];


    }

}
- (void)toNext{

    NSLog(@"___ 点击进入");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
