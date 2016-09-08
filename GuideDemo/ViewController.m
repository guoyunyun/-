//
//  ViewController.m
//  GuideDemo
//
//  Created by Yong on 16/9/1.
//  Copyright © 2016年 Yong. All rights reserved.
//

#import "ViewController.h"
#import "YYScrollView.h"

@interface ViewController ()<YYScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSArray *arr = @[@"http://a4.topitme.com/l/201009/23/12851786084240.jpg",@"http://a3.topitme.com/3/15/6b/1143796178f766b153l.jpg",@"http://a4.topitme.com/l/201007/16/12792952116032.jpg",@"http://a4.topitme.com/l/201101/26/12960178728134.jpg"];

   YYScrollView *scrollview = [YYScrollView setUpScrollViewWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 180) ImageList:[NSMutableArray arrayWithArray:arr]];
    scrollview.delegate = self;
    
    [self.view addSubview:scrollview];

}
- (void)clickImageViewWithIndex:(NSInteger)index{

    NSLog(@"_____ %ld",(long)index);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
